#!/usr/bin/env sh
# Startup Board Pro static checks.
# Usage: evals/check.sh <contract|state|advisors|phases|artifacts|skill|plugin|sweeps|cases|zip|invariants|all>
# Release builds: SBP_ZIP_FULL=1 sh evals/check.sh zip   (byte-for-byte zip comparison;
# the default zip comparison is a fast CRC-32 check, see check_zip)
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# The plugin manifests, CHANGELOG and sales page sit beside the skill folder in
# the build tree and one level above it in a buyer's install. Resolve both, so
# the suite a buyer re-runs reports drift rather than layout.
PKG="$ROOT"
_p="$ROOT"
for _i in 1 2 3; do
  if [ -d "$_p/.claude-plugin" ]; then PKG="$_p"; break; fi
  _p="$(cd "$_p/.." 2>/dev/null && pwd)" || break
  [ -n "$_p" ] || break
  if [ -d "$_p/.claude-plugin" ]; then PKG="$_p"; break; fi
done
# the sales page is README-PRO.md in the build tree and README.md in an install
if [ -f "$PKG/README-PRO.md" ]; then SALES="README-PRO.md"
elif [ -f "$PKG/README.md" ]; then SALES="README.md"
else SALES=""; fi
FAIL=0
BT=$(printf '\140')
# Pick an interpreter that actually runs. On Windows, python3 is commonly a
# Microsoft Store stub: it is on PATH, prints an install notice, and exits
# non-zero. Probing is the only way to tell a name apart from an interpreter.
PY=""
for _c in python3 python py; do
  if command -v "$_c" >/dev/null 2>&1 && "$_c" -c 'pass' >/dev/null 2>&1; then PY="$_c"; break; fi
done
fail() { echo "FAIL: $*"; FAIL=1; }
ok()   { echo "ok:   $*"; }

ADVISOR_NAMES='Fitzpatrick|Alvarez|Constable|Christensen|Steve Blank|Eric Ries|Osterwalder|Maurya|Dan Olsen|Sean Ellis|Andreessen|Cagan|Perri|Biddle|Croll|Yoskovitz|McClure|Weinberg|Balfour|Andrew Chen|Paul Graham|Ravikant|Hoffman|Feld'
BANNED_STACK='n8n|Supabase|Zapier|Make\.com|Integromat'
RETIRED_MARKERS='assumption — untested|estimate, unverified|Real or estimated'
VERDICTS='PROCEED PIVOT KILL'

has_file() { [ -f "$ROOT/$1" ] && ok "exists $1" || fail "missing $1"; }
has_str()  { grep -qF "$2" "$ROOT/$1" 2>/dev/null && ok "$1 has: $2" || fail "$1 missing: $2"; }
has_re()   { grep -qE "$2" "$ROOT/$1" 2>/dev/null && ok "$1 matches: $2" || fail "$1 missing pattern: $2"; }
pkg_file() { [ -f "$PKG/$1" ] && ok "exists $1" || fail "missing $1"; }
pkg_str()  { grep -qF "$2" "$PKG/$1" 2>/dev/null && ok "$1 has: $2" || fail "$1 missing: $2"; }
pkg_lacks_re() {
  if [ -f "$PKG/$1" ] && grep -qE "$2" "$PKG/$1" 2>/dev/null; then
    fail "$1 contains banned text: $(grep -oEm1 "$2" "$PKG/$1")"
  else ok "$1 clean of banned pattern"; fi
}
lacks_re() {
  if [ -f "$ROOT/$1" ] && grep -qE "$2" "$ROOT/$1" 2>/dev/null; then
    fail "$1 contains banned text: $(grep -oEm1 "$2" "$ROOT/$1")"
  else ok "$1 clean of banned pattern"; fi
}

check_contract() {
  has_file references/conversation-contract.md
  has_str  references/conversation-contract.md "One question per turn"
  has_str  references/conversation-contract.md "200 words"
  has_str  references/conversation-contract.md "Never compliment"
  for v in $VERDICTS; do has_str references/conversation-contract.md "$v"; done
  has_str  references/conversation-contract.md "TALK TO MORE CUSTOMERS"
  has_str  references/conversation-contract.md "accept all three"
  has_str  references/conversation-contract.md "re-ask"
  has_str  references/conversation-contract.md "Hedging is not labelling"
  has_str  references/evidence-rubric.md "own experience scores 0"
  has_str  references/evidence-rubric.md "inside of the building"
  has_file references/evidence-rubric.md
  for s in 0 1 2 3; do has_re references/evidence-rubric.md "^\| *$s *\|"; done
  has_file references/fit-ladder.md
  for s in Problem Research Product Customer Market Sales; do
    has_re references/fit-ladder.md "$s"; done
  has_re   references/fit-ladder.md '[0-9]'
}

check_state() {
  has_file references/state-file.md
  for h in Venture "Fit ladder" "Assumption ledger" "Evidence log" Numbers Decisions "Open loops" Calibration; do
    has_str references/state-file.md "## $h"; done
  for l in "OPEN LOOP" "CLOSE LOOP" "CALIBRATION LOOP"; do
    has_str references/state-file.md "$l"; done
  has_str references/state-file.md "startup-board-progress.md"
  has_str references/state-file.md "append-and-amend"
  has_str references/state-file.md "untouched on disk"
  has_str references/state-file.md "carried from v1"
  has_str references/state-file.md "Not a recap"
  has_str references/state-file.md "ask for both filenames"
}

check_advisors() {
  for n in 01-problem-discovery 02-customer-development 03-business-model \
           04-product-market-fit 05-product-management 06-metrics \
           07-traction-and-growth 08-founder-strategy 09-fundraising; do
    f="references/advisors/$n.md"
    has_file "$f"
    for h in "## When this module loads" "## The lens" "## Questions to ask, in order" \
             "## Red flags in the answer" "## The evidence this module accepts" \
             "## Output" "## Source lenses (internal)"; do
      has_str "$f" "$h"; done
    q=$(awk '/^## Questions to ask, in order/{f=1;next} /^## /{f=0} f&&/^[0-9-]/{c++} END{print c+0}' "$ROOT/$f" 2>/dev/null)
    [ "${q:-0}" -ge 6 ] && ok "$f has $q questions" || fail "$f has ${q:-0} questions, needs 6+"
  done
  for name in Fitzpatrick Alvarez Constable Christensen "Steve Blank" "Eric Ries" \
              Osterwalder Maurya "Dan Olsen" "Sean Ellis" Andreessen Cagan Perri \
              Biddle Croll Yoskovitz McClure Weinberg Balfour "Andrew Chen" \
              "Paul Graham" Ravikant Hoffman Feld; do
    grep -rqF "$name" "$ROOT/references/advisors/" 2>/dev/null \
      && ok "advisor mapped: $name" || fail "advisor not mapped anywhere: $name"
  done
}

check_phases() {
  for n in 00-intake 01-interrogation 02-fit-assessment 03-research 04-artifacts \
           05-verdict 06-mvp-blueprint 07-launch 08-positioning-and-pitch \
           09-pmf-checkin 10-scale; do
    f="phases/$n.md"
    has_file "$f"
    has_re  "$f" 'Pass gate:.*[0-9]'
    has_str "$f" "Next phase:"
    has_str "$f" "Modules:"
    lacks_re "$f" "$ADVISOR_NAMES"
    lacks_re "$f" "$BANNED_STACK"
    lacks_re "$f" "$RETIRED_MARKERS"
  done
  has_str phases/05-verdict.md "TALK TO MORE CUSTOMERS"
  has_str phases/05-verdict.md "can never reach"
  has_re  phases/05-verdict.md '^\| *0 *\|'
  has_str phases/01-interrogation.md "riskiest"
  has_str phases/06-mvp-blueprint.md "Lovable"
  has_str phases/06-mvp-blueprint.md "Built before"
  has_str phases/07-launch.md "product problem"
  has_str phases/08-positioning-and-pitch.md "never produce a valuation"
  has_str phases/08-positioning-and-pitch.md "raise-plan.md"
  has_str phases/09-pmf-checkin.md "very-disappointed survey"
  has_str phases/09-pmf-checkin.md "does not add up"
  has_str phases/09-pmf-checkin.md "waitlist is not usage"
  has_str phases/09-pmf-checkin.md "The kit is not a to-do list"
  has_str references/advisors/09-fundraising.md "dilution"
  has_str references/advisors/09-fundraising.md "comparable"
}

check_artifacts() {
  has_file references/artifacts-index.md
  has_str  references/artifacts-index.md "The filenames you write"
  has_str  references/artifacts-index.md "pmf-scorecard.md"
  has_str  references/artifacts-index.md "raise-plan.md"
  has_str  evals/rubric.md "Re-running the suite after a model update"
  has_str  references/artifacts/raise-plan.md "never produce a valuation"
  has_str  references/artifacts/raise-plan.md "Dilution"
  for a in lean-canvas mom-test-script pmf-survey positioning-statement \
           pitch-deck-outline one-pager cac-ltv-model experiment-card \
           market-research-brief naming-shortlist launch-plan \
           build-prompt-library growth-plan pmf-scorecard raise-plan; do
    f="references/artifacts/$a.md"
    has_file "$f"
    lacks_re "$f" "$ADVISOR_NAMES"
    lacks_re "$f" "$RETIRED_MARKERS"
    lacks_re "$f" "$BANNED_STACK"
  done
  for a in lean-canvas pmf-survey cac-ltv-model pitch-deck-outline one-pager \
           experiment-card market-research-brief growth-plan pmf-scorecard raise-plan; do
    has_str "references/artifacts/$a.md" "UNVERIFIED"
  done
}

check_skill() {
  has_file SKILL.md
  # The frontmatter must be valid YAML, not merely delimited. A colon followed
  # by a space inside an unquoted scalar silently terminates the value, which
  # would truncate the trigger description and is invisible to a behavioural
  # run, because a role-play reads the file as prose and never parses it.
  fm=$(awk 'NR==1&&/^---$/{f=1;next} f&&/^---$/{exit} f{print}' "$ROOT/SKILL.md" 2>/dev/null)
  if printf '%s' "$fm" | grep -qE '^description:.*: '; then
    fail "SKILL.md frontmatter has a colon-space inside the description, which breaks YAML parsing"
  else ok "SKILL.md description has no YAML-breaking colon"; fi
  if printf '%s' "$fm" | grep -qE '^name: *[a-z0-9-]+$'; then
    ok "SKILL.md name is a bare slug"
  else fail "SKILL.md name is missing or not a bare slug"; fi
  if [ -n "$PY" ] && "$PY" -c 'import yaml' 2>/dev/null; then
    if printf '%s' "$fm" | "$PY" -c 'import sys,yaml;d=yaml.safe_load(sys.stdin.read());assert isinstance(d,dict) and d.get("name") and d.get("description")' 2>/dev/null; then
      ok "SKILL.md frontmatter parses as YAML with name and description"
    else
      fail "SKILL.md frontmatter does not parse as YAML"
    fi
  else
    ok "SKILL.md YAML parse skipped (no interpreter with pyyaml); the colon check above still applies"
  fi
  n=$(wc -l < "$ROOT/SKILL.md" 2>/dev/null || echo 9999)
  n=${n:-9999}
  [ "$n" -lt 500 ] && ok "SKILL.md is $n lines (<500)" || fail "SKILL.md is $n lines, must be under 500"
  lacks_re SKILL.md "$ADVISOR_NAMES"
  lacks_re SKILL.md "$BANNED_STACK"
  lacks_re SKILL.md "$RETIRED_MARKERS"
  for v in $VERDICTS; do has_str SKILL.md "$v"; done
  has_str SKILL.md "TALK TO MORE CUSTOMERS"
  broken=0
  for p in $(grep -oE "${BT}(references|phases)/[a-z0-9./-]+\.md${BT}" "$ROOT/SKILL.md" 2>/dev/null | tr -d "$BT" | sort -u); do
    if [ -f "$ROOT/$p" ]; then ok "link resolves $p"; else fail "SKILL.md links missing $p"; broken=1; fi
  done
  [ "$broken" -eq 0 ] && ok "all SKILL.md links resolve"
}

check_plugin() {
  pkg_file .claude-plugin/plugin.json
  # marketplace.json was removed on 2026-10-13 with the plugin route: a
  # marketplace listing is inert without a marketplace repository, and the one
  # it named now 404s. plugin.json stays, because it is the plugin's own
  # identity and the description assertion below catches drift against
  # SKILL.md's frontmatter.
  for _f in .claude-plugin/plugin.json; do
    [ -f "$PKG/$_f" ] || continue
    if [ -n "$PY" ]; then
      if "$PY" -c 'import json,sys;json.load(sys.stdin)' < "$PKG/$_f" 2>/dev/null; then
        ok "$_f is valid JSON"
      else fail "$_f is not valid JSON"; fi
    else ok "$_f JSON parse skipped (no interpreter found)"; fi
  done
  pkg_str  .claude-plugin/plugin.json '"name": "startup-board-pro"'
  pkg_str  .claude-plugin/plugin.json '"version": "2.1.0"'
  pkg_str  CHANGELOG.md "2.1.0"
  pkg_lacks_re .claude-plugin/plugin.json "$ADVISOR_NAMES"
  pkg_lacks_re .claude-plugin/plugin.json "$BANNED_STACK"
  d1=$(sed -n 's/^description: *//p' "$ROOT/SKILL.md" 2>/dev/null | head -1 | cut -c1-60)
  if [ -n "$d1" ] && grep -qF "$d1" "$PKG/.claude-plugin/plugin.json" 2>/dev/null; then
    ok "plugin.json description matches SKILL.md frontmatter"
  else
    fail "plugin.json description does not match SKILL.md frontmatter"
  fi
}

# Sweeps that apply to whole directories, not one named file.
# These exist because three answer keys shipped demanding retired markers and
# the v1 filename, and nothing was looking at evals/criteria at all.
check_sweeps() {
  for f in "$ROOT"/references/*.md "$ROOT"/evals/criteria/*.md "$ROOT"/evals/rubric.md            ${SALES:+"$PKG/$SALES"} "$PKG"/dist/*.md "$PKG"/dist/launch/*.md; do
    [ -f "$f" ] || continue
    rel=${f#"$ROOT"/}; rel=${rel#"$PKG"/}
    # retired unverified markers, anywhere a founder or a grader can read them
    if grep -qE "$RETIRED_MARKERS" "$f" 2>/dev/null; then
      fail "$rel uses a retired marker: $(grep -oEm1 "$RETIRED_MARKERS" "$f")"
    else ok "$rel clean of retired markers"; fi
    # the v1 progress filename is allowed only where migration is the subject
    case "$rel" in
      references/state-file.md|evals/criteria/s02-*|evals/criteria/s03-*|evals/criteria/s04-*|dist/INSTALL.md|dist/CHANGELOG.md|dist/EDITION-SPLIT.md|README-PRO.md) ;;
      *)
        if grep -qF 'startup-board-progress.md' "$f" 2>/dev/null; then
          fail "$rel names the v1 progress file outside the migration path"
        else ok "$rel clean of the v1 filename"; fi ;;
    esac
    # v1 stage names were renamed; the keys must not ask for a string the skill never emits
    if grep -qE 'Problem Fit|Market Fit|Sales Fit|Research Fit|Product Fit|Customer Fit' "$f" 2>/dev/null; then
      fail "$rel uses a v1 stage name: $(grep -oEm1 'Problem Fit|Market Fit|Sales Fit|Research Fit|Product Fit|Customer Fit' "$f")"
    else ok "$rel clean of v1 stage names"; fi
  done
  # advisor names must not appear in anything shipped outside references/advisors
  for f in "$ROOT"/references/*.md ${SALES:+"$PKG/$SALES"} "$PKG"/dist/*.md "$PKG"/dist/launch/*.md; do
    [ -f "$f" ] || continue
    rel=${f#"$ROOT"/}; rel=${rel#"$PKG"/}
    if grep -qE "$ADVISOR_NAMES" "$f" 2>/dev/null; then
      fail "$rel names an advisor: $(grep -oEm1 "$ADVISOR_NAMES" "$f")"
    else ok "$rel names no advisor"; fi
  done
  # README-PRO links must resolve from where a buyer actually unpacks them
  if [ -n "$SALES" ]; then
    for lp in $(grep -oE "${BT}(evals|references|phases)/[a-zA-Z0-9./-]+${BT}|${BT}INSTALL\.md${BT}" "$PKG/$SALES" 2>/dev/null | tr -d "$BT" | sort -u); do
      if [ -f "$ROOT/$lp" ] || [ -f "$PKG/$lp" ]; then ok "$SALES link resolves: $lp"
      else fail "$SALES links missing $lp"; fi
    done
  fi

    # The sales page must not point at anything the zip leaves out. The
    # exclusion list is the one build-zip.sh and check_zip() share; it lives in
    # the build tree only, so a buyer's install skips this (and cannot have the
    # problem: the page there was already checked against the archive).
    _xl="$ROOT/../payload-exclude.txt"
    if [ -f "$_xl" ]; then
      _xpats=$(sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' "$_xl" | grep -v '^$')
      if [ -z "$_xpats" ]; then
        fail "payload-exclude.txt at $_xl holds no patterns; cannot check $SALES against it"
      else
        for lp in $(grep -oE "${BT}(evals|references|phases)/[a-zA-Z0-9./-]+${BT}|${BT}INSTALL\.md${BT}" "$PKG/$SALES" 2>/dev/null | tr -d "$BT" | sort -u); do
          _hit=""
          while IFS= read -r _p; do
            case "$lp" in $_p) _hit="$_p"; break ;; esac
            case "$lp/" in $_p) _hit="$_p"; break ;; esac
          done <<EOF_XPATS
$_xpats
EOF_XPATS
          if [ -n "$_hit" ]; then fail "$SALES references $lp, which payload-exclude.txt excludes (pattern: $_hit)"
          else ok "$SALES does not reference excluded path: $lp"; fi
        done
      fi
    else
      ok "sales-page vs payload-exclude.txt check skipped (no payload-exclude.txt beside the skill folder; build tree only): $SALES was NOT checked against the exclusions"
    fi

  # every rule of thumb carries its label at the point of use
  for f in "$ROOT"/references/fit-ladder.md "$ROOT"/phases/09-pmf-checkin.md "$ROOT"/phases/10-scale.md; do
    rel=${f#"$ROOT"/}
    n=$(grep -oE '\(rules? of thumb\)' "$f" 2>/dev/null | wc -l)
    [ "${n:-0}" -ge 3 ] && ok "$rel labels $n rules of thumb"       || fail "$rel labels only ${n:-0} rules of thumb, needs 3 or more inline"
    if grep -qE '\(rule of$' "$f" 2>/dev/null; then
      fail "$rel splits a (rule of thumb) label across a line break, so it is not greppable"
    else ok "$rel has no split rule-of-thumb label"; fi
  done
}

check_cases() {
  # The expected total, defined once. Adding a case is a one-line change here.
  # Two literals drifting apart is how this count went stale twice in one day
  # (21 -> 28 on 2026-10-13).
  _expect=28
  c=$(ls "$ROOT/evals/cases" 2>/dev/null | wc -l)
  k=$(ls "$ROOT/evals/criteria" 2>/dev/null | wc -l)
  [ "$c" -eq "$_expect" ] && ok "$_expect cases" || fail "$c cases, expected $_expect"
  [ "$k" -eq "$_expect" ] && ok "$_expect criteria" || fail "$k criteria, expected $_expect"
  for f in "$ROOT/evals/cases/"*.md; do
    [ -e "$f" ] || continue
    b=$(basename "$f")
    [ -f "$ROOT/evals/criteria/$b" ] && ok "criteria pair $b" || fail "no criteria for $b"
  done
}

# The installable zip for routes 1 and 2. It is a build artifact: gitignored,
# absent from a fresh clone and from a buyer's install, so an absent zip is a
# skip and a present one is asserted hard.
#
# Windows PowerShell 5.1 Compress-Archive stored 107 of 112 entries with "\"
# separators, against ZIP spec 4.4.17.1, which requires "/". Info-ZIP unzip
# silently repairs that on read and macOS Archive Utility does not: there it
# extracts one flat file named "references\fit-ladder.md", and every link in
# SKILL.md resolves to nothing. The original build verified the zip with
# PowerShell Expand-Archive, the same pair that wrote the bug, so the verify
# could never see it. Hence this group reads the stored names, not an extract.
# The Python fallback must read orig_filename: namelist() normalizes backslash to
# slash on read, which would repair the very defect this group exists to catch.
check_zip() {
  _zip="${1:-$PKG/dist/startup-board-pro.zip}"
  if [ ! -f "$_zip" ] && [ -n "${1:-}" ]; then
    fail "no zip at $_zip (an explicit path was given and does not exist)"
    return
  fi
  if [ ! -f "$_zip" ]; then
    ok "no zip at dist/startup-board-pro.zip (build artifact; run sh build-zip.sh (from the repo root) to make one)"
    return
  fi
  _names=""
  if command -v unzip >/dev/null 2>&1; then
    _names=$(unzip -Z1 "$_zip" 2>/dev/null)
  fi
  if [ -z "$_names" ] && [ -n "$PY" ]; then
    _names=$("$PY" -c 'import sys,zipfile;print("\n".join(i.orig_filename for i in zipfile.ZipFile(sys.argv[1]).infolist()))' "$_zip" 2>/dev/null | tr -d '\r')
  fi
  if [ -z "$_names" ]; then
    fail "cannot read zip entry names from $_zip (no unzip and no working interpreter, or the archive is corrupt)"
    return
  fi

  # The manifest decides which uploader accepts this archive, so assert it
  # directly rather than inferring it from the payload comparison. Without
  # this, a plugin build whose source lost .claude-plugin/plugin.json would
  # match its (equally manifest-less) source tree and pass as a plugin zip.
  if printf '%s\n' "$_names" | sed 's|\\|/|g' | grep -qx '\.claude-plugin/plugin\.json'; then
    if [ "${SBP_ZIP_WITH_MANIFEST:-0}" = "1" ]; then
      ok "zip carries .claude-plugin/plugin.json at the archive root (plugin upload route)"
    else
      fail "zip carries .claude-plugin/plugin.json; the Claude app's skill uploader refuses that archive. Build the plugin archive with sh build-zip.sh plugin instead"
    fi
  else
    if [ "${SBP_ZIP_WITH_MANIFEST:-0}" = "1" ]; then
      fail "zip has no .claude-plugin/plugin.json at the archive root, so the plugin uploader will refuse it"
    else
      ok "zip carries no plugin manifest (skill upload route)"
    fi
  fi

  _bs=$(printf '%s\n' "$_names" | grep -c '[\]' || true)
  if [ "$_bs" -eq 0 ]; then
    ok "zip stores no backslash path separators"
  else
    fail "zip stores $_bs entries with backslash separators (ZIP spec 4.4.17.1 requires /); rebuild with sh build-zip.sh (from the repo root)"
  fi

  # Entries ending in / are directory records. bsdtar writes them and
  # Compress-Archive did not, so compare files only.
  _zip_files=$(printf '%s\n' "$_names" | sed 's|\\|/|g' | grep -v '/$' | LC_ALL=C sort)
  # The exclusion list is shared with build-zip.sh and lives only in the build
  # tree, next to it. We reach here only when an archive exists, which means a
  # build tree. Never fall back to a built-in list: that is the bug this prevents.
  _xl="$ROOT/../payload-exclude.txt"
  if [ ! -f "$_xl" ]; then
    fail "payload-exclude.txt not found at $_xl; the zip guard and build-zip.sh share that one list and the guard will not guess one"
    return
  fi
  _pats=$(sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' "$_xl" | grep -v '^$')
  # The plugin archive is the skill archive plus .claude-plugin/plugin.json.
  # build-zip.sh plugin sets SBP_ZIP_WITH_MANIFEST=1 so this guard expects the
  # manifest instead of flagging it as an extra file. The variable drops that
  # one pattern and nothing else: the two archives are held to the same list,
  # which is the point of there being only one list.
  if [ "${SBP_ZIP_WITH_MANIFEST:-0}" = "1" ]; then
    _pats=$(printf '%s
' "$_pats" | grep -vxF '.claude-plugin/*')
  fi
  if [ -z "$_pats" ]; then
    fail "payload-exclude.txt at $_xl holds no patterns"
    return
  fi
  _src_files=$(cd "$ROOT" && find . -type f | sed 's|^\./||' | while IFS= read -r _f; do
    _skip=0
    while IFS= read -r _p; do
      case "$_f" in $_p) _skip=1; break ;; esac
    done <<EOF_PATTERNS
$_pats
EOF_PATTERNS
    [ "$_skip" -eq 0 ] && printf '%s
' "$_f"
  done | LC_ALL=C sort)
  if [ "$_zip_files" = "$_src_files" ]; then
    ok "zip payload matches the source tree ($(printf '%s\n' "$_src_files" | grep -c .) files, nothing missing, nothing extra)"
  else
    fail "zip payload differs from the source tree; rebuild with sh build-zip.sh (from the repo root)"
    printf '%s\n' "$_src_files" > "${TMPDIR:-/tmp}/sbp-src.$$"
    printf '%s\n' "$_zip_files" > "${TMPDIR:-/tmp}/sbp-zip.$$"
    diff "${TMPDIR:-/tmp}/sbp-src.$$" "${TMPDIR:-/tmp}/sbp-zip.$$" | sed 's/^/      /'
    rm -f "${TMPDIR:-/tmp}/sbp-src.$$" "${TMPDIR:-/tmp}/sbp-zip.$$"
  fi

  # Names alone cannot see a stale archive: a payload file edited after the
  # build keeps its name. Two ways to compare contents.
  #
  # DEFAULT, fast: compare CRC-32. The zip stores a CRC-32 for every entry, so
  # each shipped source file's CRC-32 is compared with the stored one and
  # nothing is extracted. (The old extract-and-cmp path took about 23 seconds
  # and pushed `check.sh all` past a 120-second timeout.)
  #   What a CRC match proves: the file has not drifted by accident, such as a
  #   source file edited after the build or a stale archive.
  #   What it does NOT prove: it is NOT a byte-for-byte proof and NOT
  #   tamper-evident. CRC-32 is a checksum, not a cryptographic hash, and
  #   collisions can be constructed on purpose.
  # FULL, slow: set SBP_ZIP_FULL=1 to extract the archive and cmp every file
  #   byte for byte. A release build uses this one:
  #     SBP_ZIP_FULL=1 sh evals/check.sh zip
  # The output line says which comparison ran, so read it before trusting it.
  if [ "${SBP_ZIP_FULL:-}" = "1" ]; then
    _tmp=""; _ex=""
    if command -v unzip >/dev/null 2>&1; then
      _tmp=$(mktemp -d "${TMPDIR:-/tmp}/sbp-ex.XXXXXX" 2>/dev/null) && unzip -q "$_zip" -d "$_tmp" >/dev/null 2>&1 && _ex="$_tmp"
    elif [ -n "$PY" ]; then
      _tmp=$(mktemp -d "${TMPDIR:-/tmp}/sbp-ex.XXXXXX" 2>/dev/null) && "$PY" -c 'import sys,zipfile;zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])' "$_zip" "$_tmp" >/dev/null 2>&1 && _ex="$_tmp"
    fi
    if [ -n "$_ex" ]; then
      _drift=$(printf '%s\n' "$_src_files" | while IFS= read -r _f; do
        cmp -s "$ROOT/$_f" "$_ex/$_f" || echo "differs or missing: $_f"
      done)
      if [ -z "$_drift" ]; then
        ok "zip contents are byte-for-byte identical to the source tree (full comparison, SBP_ZIP_FULL=1)"
      else
        fail "zip contents differ from the source tree (stale archive?); rebuild with sh build-zip.sh (from the repo root)"
        printf '%s\n' "$_drift" | sed 's/^/      /'
      fi
    elif command -v unzip >/dev/null 2>&1 || [ -n "$PY" ]; then
      fail "could not extract $_zip to compare its contents against the source tree"
    else
      ok "zip full content comparison skipped (no unzip, no working interpreter): file names were checked, file contents were NOT"
    fi
    [ -n "$_tmp" ] && rm -rf "$_tmp"
  else
    _crcdone=0
    if [ -n "$PY" ]; then
      _drift=$(printf '%s\n' "$_src_files" | "$PY" -c '
import sys, zipfile, zlib
z = zipfile.ZipFile(sys.argv[1])
stored = {i.orig_filename.replace("\\", "/"): i.CRC for i in z.infolist()}
for n in sys.stdin.read().split("\n"):
    if not n:
        continue
    if n not in stored:
        print("differs or missing: " + n)
        continue
    with open(sys.argv[2] + "/" + n, "rb") as fh:
        if zlib.crc32(fh.read()) & 0xFFFFFFFF != stored[n]:
            print("differs or missing: " + n)
' "$_zip" "$ROOT" 2>&1) && _crcdone=1
    elif command -v unzip >/dev/null 2>&1 && command -v gzip >/dev/null 2>&1; then
      # Source CRC-32 comes from the gzip trailer: the CRC-32 of the
      # uncompressed data, little-endian, in the last 8 bytes minus the final 4.
      _tbl=$(unzip -v "$_zip" 2>/dev/null | awk 'NF>=8 && length($7)==8 && $7 ~ /^[0-9a-f]+$/ {n=$0; sub(/^ *([^ ]+ +){7}/,"",n); print $7 " " n}')
      if [ -n "$_tbl" ]; then
        _drift=$(printf '%s\n' "$_src_files" | while IFS= read -r _f; do
          set -- $(gzip -c < "$ROOT/$_f" | tail -c8 | head -c4 | od -An -tx1)
          _have="$4$3$2$1"
          _want=$(printf '%s\n' "$_tbl" | awk -v n="$_f" 'substr($0,10)==n {print substr($0,1,8); exit}')
          [ "$_have" = "$_want" ] || echo "differs or missing: $_f"
        done)
        _crcdone=1
      fi
    fi
    if [ "$_crcdone" -eq 1 ]; then
      if [ -z "$_drift" ]; then
        ok "zip CRC-32 of every shipped file matches the source tree (checksum comparison: catches accidental drift, NOT byte-for-byte proof, NOT tamper-evident; SBP_ZIP_FULL=1 runs the full comparison)"
      else
        fail "zip CRC-32 differs from the source tree (stale archive?); rebuild with sh build-zip.sh (from the repo root)"
        printf '%s\n' "$_drift" | sed 's/^/      /'
      fi
    else
      ok "zip content comparison skipped (no working interpreter, and no unzip with gzip): file names were checked, file contents were NOT"
    fi
  fi

  for _x in AUDIT.md dist/ _reference/ .git/; do
    if printf '%s\n' "$_zip_files" | grep -q "^$(printf '%s' "$_x" | sed 's/[.]/[.]/g')"; then
      fail "zip leaks $_x"
    else
      ok "zip excludes $_x"
    fi
  done

  if command -v unzip >/dev/null 2>&1; then
    if unzip -p "$_zip" SKILL.md 2>/dev/null | head -1 | grep -q '^---'; then
      ok "zip SKILL.md opens with a frontmatter fence"
    else
      fail "zip SKILL.md has no opening frontmatter fence"
    fi
  else
    ok "zip SKILL.md frontmatter check skipped (no unzip found)"
  fi
}

# ---------------------------------------------------------------------------
# Static invariants. WHY THIS GROUP EXISTS: on 2026-10-13 a phase file was
# edited to refuse something outright that was NOT one of the three sanctioned
# refusals, and an eval case written to verify the fix PASSED, because the same
# agent wrote the fix and the answer key. The eval certified the contradiction.
# An eval cannot catch an invariant violation when the violator grades it; a
# static check reading the shipped files can. Do not delete this group as
# redundant with evals/cases.
#
# The invariant, from references/fit-ladder.md ("Three things are refused
# outright, and they are the only three") and conversation-contract.md
# ("Never refuse."): everything except the listed refusals is warn, allow, stamp.

# Print each numbered item of the list that follows the first line of file $1
# matching ERE $2, one item per output line (continuation lines joined). The
# list ends at the first non-blank line that is neither an item nor indented.
_list_items() {
  awk -v pat="$2" '
    !on && $0 ~ pat { on=1; next }
    on {
      if ($0 ~ /^[0-9]+\. /) { if (cur != "") print cur; cur=$0; started=1; next }
      if (started && $0 ~ /^[ \t]+[^ \t]/) { cur = cur " " $0; next }
      if ($0 ~ /^[ \t]*$/) { next }
      if (started) { exit }
    }
    END { if (cur != "") print cur }
  ' "$ROOT/$1" 2>/dev/null
}

check_invariants() {
  _fl=references/fit-ladder.md
  _cc=references/conversation-contract.md
  _refpat='are refused outright'

  # 1. The refusal list is parsed, never hardcoded: the written count word must
  # equal the number of items actually listed under it.
  _word=$(sed -n 's/^\*\*\([A-Za-z]*\) things are refused outright.*/\1/p' "$ROOT/$_fl" 2>/dev/null | head -1)
  _n=$(_list_items "$_fl" "$_refpat" | grep -c .)
  case $(printf '%s' "$_word" | tr 'A-Z' 'a-z') in
    one) _w=1 ;; two) _w=2 ;; three) _w=3 ;; four) _w=4 ;; five) _w=5 ;;
    six) _w=6 ;; seven) _w=7 ;; *) _w="" ;;
  esac
  if [ -z "$_w" ]; then
    fail "$_fl: cannot find the 'N things are refused outright' count word (found: '${_word}')"
  elif [ "$_n" -eq "$_w" ]; then
    ok "$_fl count word '$_word' ($_w) matches the $_n listed refusals"
  else
    fail "$_fl says '$_word' ($_w) things are refused outright but lists $_n"
  fi

  # 2. No phase introduces an unsanctioned refusal.
  # HEURISTIC (noisy on purpose). Split each phase into blank-line paragraphs.
  # A paragraph is SUSPECT if it contains outright-refusal vocabulary:
  #   refus*, "do not run this phase", "turned away".
  # A suspect paragraph is CLEARED if it also contains any of:
  #   (a) a pointer to the list: "fit-ladder", "sanctioned", "one of only three",
  #       "one of the three";
  #   (b) a negation: "not a refusal", "never a refusal", "not a fourth",
  #       "never refuse";
  #   (c) a topic anchor of one of the three: "zero active users",
  #       "market siz", "unverifiable".
  # Anything else FAILS with file:line. BLIND SPOTS: (1) it matches vocabulary,
  # so a refusal worded without it ("will not answer", "never produce X",
  # "do not produce") is invisible; that wording is also how the legitimate
  # unasked-below-gate rule reads, so it is deliberately not matched.
  # (2) clearing is per paragraph, so a new refusal that shares a paragraph with
  # a cleared phrase, or that merely mentions market sizing, zero users or an
  # unverifiable claim, passes. (3) a pointer to fit-ladder is not proof the
  # refusal is one of the three. (4) it cannot tell a refusal from a sentence
  # that quotes one. Failures are therefore leads for a human, and a pass is not
  # a proof.
  _bad=0
  for _f in "$ROOT"/phases/*.md; do
    [ -f "$_f" ] || continue
    _rel=${_f#"$ROOT"/}
    _hits=$(awk '
      function flush() {
        if (para != "" && hit != "") {
          t = tolower(para)
          cleared = (t ~ /fit-ladder|sanctioned|one of only three|one of the three/) ||
                    (t ~ /not a refusal|never a refusal|not a fourth|never refuse/) ||
                    (t ~ /zero active users|market siz|unverifiable/)
          if (!cleared) print FILENAME ":" hitline ": " hit
        }
        para=""; hit=""; nl=0
      }
      /^[ \t]*$/ { if (nl == 1 && para ~ /^ #/) next; flush(); next }
      { para = para " " $0; nl++
        if (hit == "" && tolower($0) ~ /refus|do not run this phase|turned away/) { hit=$0; hitline=NR } }
      END { flush() }
    ' "$_f")
    if [ -n "$_hits" ]; then
      _bad=1
      fail "$_rel has refusal language outside the three sanctioned refusals:"
      printf '%s\n' "$_hits" | sed 's/^/      /'
    else ok "$_rel: every refusal is one of the three, or negated"; fi
  done
  [ "$_bad" -eq 0 ] && ok "no phase refuses on its own authority"

  # 3. The contract and fit-ladder agree. PROXY, not a semantic check: (a) the
  # contract still contains its bare "Never refuse." AND the exception heading
  # "The three sanctioned refusals are the only exception"; (b) the numbered
  # block under that heading has the same number of items as fit-ladder's list;
  # (c) the bold lead phrases of those items are identical between the files.
  # What it cannot see: a contract paragraph that contradicts the list in prose
  # without touching these anchors, or items whose bold phrase is unchanged but
  # whose meaning was rewritten.
  _exc='sanctioned refusals are the only exception'
  has_str $_cc "Never refuse."
  has_str $_cc "$_exc"
  has_str $_cc "references/fit-ladder.md"
  _cn=$(_list_items "$_cc" "$_exc" | grep -c .)
  if [ "$_cn" -eq "$_n" ] && [ "$_n" -gt 0 ]; then
    ok "contract exception block lists $_cn refusals, same as fit-ladder ($_n)"
  else
    fail "contract exception block lists $_cn refusals, fit-ladder lists $_n"
  fi
  _bf=$(_list_items "$_fl" "$_refpat" | grep -oE '\*\*[^*]+\*\*' | sed 's/\*\*//g; s/ *$//')
  _bc=$(_list_items "$_cc" "$_exc"    | grep -oE '\*\*[^*]+\*\*' | sed 's/\*\*//g; s/ *$//')
  if [ -n "$_bf" ] && [ "$_bf" = "$_bc" ]; then
    ok "contract and fit-ladder name the same refusals (bold phrases identical)"
  else
    fail "contract and fit-ladder refusal phrases differ: fit-ladder=[$(printf '%s' "$_bf" | tr '\n' '|')] contract=[$(printf '%s' "$_bc" | tr '\n' '|')]"
  fi

  # 4. Every phase states a numeric pass gate.
  for _f in "$ROOT"/phases/*.md; do
    [ -f "$_f" ] || continue
    _rel=${_f#"$ROOT"/}
    if grep -qE '^\*\*Pass gate:\*\*.*[0-9]' "$_f" 2>/dev/null; then
      ok "$_rel states a numeric Pass gate"
    else fail "$_rel has no '**Pass gate:**' line containing a digit"; fi
  done
  # Substituted for "no gate lower than the contract permits": the contract sets
  # no numeric floor, so none is invented here. The checkable neighbour: every
  # artifact-producing phase has a below-gate path.
  # Derived from the files, not listed here. A hardcoded list is a second place
  # to forget: the first draft of this check named seven phases by hand and
  # missed 01-interrogation.md, which declares an Artifact line too.
  for _f2 in "$ROOT"/phases/*.md; do
    [ -e "$_f2" ] || continue
    grep -q '^\*\*Artifact:\*\* `' "$_f2" || continue
    _n2=$(basename "$_f2" .md)
    has_str "phases/$_n2.md" "## When the gate is not met"
  done

  # 5. An artifact's gate agrees across its homes. WHY: on 2026-10-13 five
  # defects shared one shape, a requirement stated in one file and contradicted
  # or unreinforced in another with nothing asserting the pair; three surfaced
  # only when a blind eval failed. Defect #3: artifacts-index.md demanded score 2
  # for positioning-statement.md while phases/07-launch.md's gate named no score.
  # The index table is parsed, never listed here, so the check follows the file.
  # Per row: the artifact file exists; every phase in column 2 exists; each
  # phase's **Artifact:** block names the artifact; and the integers in column 3
  # (after dropping "Phase NN" references) do not exceed the highest integer in
  # the owning phase's **Pass gate:** line or **Artifact:** block. A score stated
  # on the Artifact block counts, because phase 07 states a per-artifact condition
  # there. A column-3 minimum of 0 demands nothing. BLIND SPOTS: integers are
  # matched as digits, so "3x CAC" or "12 months" in a gate can satisfy a
  # smaller demanded score; "highest integer" is a proxy for "states that score";
  # prose gates ("Problem passed") are skipped, not interpreted.
  _ix=references/artifacts-index.md
  _rows=$(grep -E '^\| `references/artifacts/[^`]+\.md` \|' "$ROOT/$_ix" 2>/dev/null)
  if [ -z "$_rows" ]; then
    fail "$_ix: no artifact table rows found (header '| Artifact | Earned at | Min score | Format |')"
  fi
  while IFS='|' read -r _e1 _c1 _c2 _c3 _rest; do
    [ -n "$_c1" ] || continue
    _art=$(printf '%s' "$_c1" | tr -d '` ')
    _abase=${_art##*/}
    if [ -f "$ROOT/$_art" ]; then ok "$_ix row $_abase: artifact file exists"
    else fail "$_ix row names $_art but that file does not exist"; fi
    _want=$(printf '%s' "$_c3" | sed -E 's/Phase [0-9]+//g' | grep -oE '[0-9]+' | sort -n | tail -1)
    _nums=$(printf '%s' "$_c2" | grep -oE '[0-9]{2}')
    if [ -z "$_nums" ]; then fail "$_ix row $_abase: column 2 '$(printf '%s' "$_c2" | sed 's/^ *//; s/ *$//')' names no phase"; continue; fi
    for _pn in $_nums; do
      set -- "$ROOT"/phases/"$_pn"-*.md
      _pf=$1
      if [ ! -f "$_pf" ]; then fail "$_ix row $_abase: names Phase $_pn but phases/$_pn-*.md does not exist"; continue; fi
      _prel=phases/${_pf##*/}
      _ablk=$(awk '/^\*\*Artifact:\*\*/ {on=1; print; next} on { if ($0 ~ /^[ \t]*$/ || $0 ~ /^\*\*/ || $0 ~ /^#/) exit; print }' "$_pf")
      _gate=$(grep -E '^\*\*Pass gate:\*\*' "$_pf" | head -1)
      case $_ablk in
        *"$_abase"*) ok "$_prel: Artifact line names $_abase" ;;
        *) fail "$_prel: Artifact line does not mention $_abase (the $_ix row says Phase $_pn earns it)" ;;
      esac
      if [ -z "$_want" ] || [ "$_want" -eq 0 ]; then
        ok "$_ix row $_abase vs $_prel: score comparison skipped, column 3 '$(printf '%s' "$_c3" | sed 's/^ *//; s/ *$//')' demands no integer score"
        continue
      fi
      _have=$(printf '%s\n%s\n' "$_gate" "$_ablk" | sed -E 's/Phase [0-9]+//g' | grep -oE '[0-9]+' | sort -n | tail -1)
      if [ -z "$_have" ]; then
        fail "$_ix row $_abase demands score $_want ('$(printf '%s' "$_c3" | sed 's/^ *//; s/ *$//')') but $_prel's Pass gate and Artifact lines state no score. gate: $_gate"
      elif [ "$_want" -gt "$_have" ]; then
        fail "$_ix row $_abase demands score $_want but $_prel states at most $_have. gate: $_gate"
      else
        ok "$_ix row $_abase demands $_want, $_prel states up to $_have"
      fi
    done
  done <<EOF
$_rows
EOF

  # 6. A rule split across files declares both halves. WHY: the same 2026-10-13
  # defects; the rule-4 split (conversation-contract.md section 1 and
  # evidence-rubric.md) was specified with each half naming the other because a
  # one-way pointer is what decays. Every block opening with the marker phrase,
  # in any file under references/ or phases/, must name at least one other file
  # that exists and carries the marker itself. Blocks are the marker line plus the
  # consecutive '>' lines after it. BLIND SPOT: reciprocity is per file, not per
  # block, so a second, unrelated block in the target would satisfy the pointer.
  _mk='Where this rule is split, and why.'
  _mf=$(grep -rlF -- "$_mk" "$ROOT/references" "$ROOT/phases" 2>/dev/null | sort)
  if [ -z "$_mf" ]; then
    fail "no file under references/ or phases/ carries the '$_mk' marker"
  fi
  for _f3 in $_mf; do
    _r3=${_f3#"$ROOT"/}
    _bl=$(awk -v mk="$_mk" '
      function flush(  t) {
        if (!inb) return
        t = txt; found = 0
        while (match(t, /(references|phases)\/[A-Za-z0-9_\/.-]+\.md/)) {
          print start, substr(t, RSTART, RLENGTH); found = 1; t = substr(t, RSTART + RLENGTH)
        }
        if (!found) print start, "-"
        inb = 0
      }
      { if (inb && $0 !~ /^>/) flush()
        if (!inb && $0 ~ /^>/ && index($0, mk)) { inb = 1; start = NR; txt = "" }
        if (inb) txt = txt " " $0 }
      END { flush() }
    ' "$_f3")
    while read -r _ln _tg; do
      [ -n "$_ln" ] || continue
      if [ "$_tg" = "-" ]; then fail "$_r3:$_ln: split-rule block names no other file"; continue; fi
      if [ "$_tg" = "$_r3" ]; then continue; fi
      if [ ! -f "$ROOT/$_tg" ]; then
        fail "$_r3:$_ln: split-rule block points at $_tg, which does not exist"
      elif grep -qF -- "$_mk" "$ROOT/$_tg"; then
        ok "$_r3:$_ln: split-rule block points at $_tg, which carries the reciprocal block"
      else
        fail "$_r3:$_ln: dangling pointer, split-rule block points at $_tg, which has no '$_mk' block"
      fi
    done <<EOF
$_bl
EOF
  done
}

case "${1:-all}" in
  contract)  check_contract ;;
  state)     check_state ;;
  advisors)  check_advisors ;;
  phases)    check_phases ;;
  artifacts) check_artifacts ;;
  skill)     check_skill ;;
  plugin)    check_plugin ;;
  sweeps)    check_sweeps ;;
  cases)     check_cases ;;
  zip)       check_zip "${2:-}" ;;
  invariants) check_invariants ;;
  all) check_contract; check_state; check_advisors; check_phases
       check_artifacts; check_skill; check_plugin; check_sweeps; check_cases
       check_zip; check_invariants ;;
  *) echo "usage: $0 <contract|state|advisors|phases|artifacts|skill|plugin|sweeps|cases|zip|invariants|all>"; exit 2 ;;
esac

[ "$FAIL" -eq 0 ] && echo "PASS" || echo "FAILED"
exit "$FAIL"
