#!/usr/bin/env sh
# Sync the shipped skill from this dev tree into the buyer-facing repository.
#
# DRAFT, 2026-10-13. Never run. Written before the repo split was executed, so
# the destination does not exist yet and step 0 will refuse until it does.
#
# Why this exists rather than a manual copy: the distribution repository that
# was deleted today held a copy of pro/ kept in step by hand. Two copies of the
# same files synced by hand is the arrangement that produced a duplicate nobody
# could prove was identical. This makes drift a failure instead of a discipline
# problem. It refuses rather than repairs.
#
# Usage:  sh sync-dist.sh /path/to/startupboardskills-checkout
#         sh sync-dist.sh --dry-run /path/to/checkout
#
# It never commits, never pushes, never creates a release and never touches a
# remote. It leaves a staged working tree for a human to inspect and commit.
set -u

CDPATH=
SRC="$(cd "$(dirname "$0")" && pwd)" || { echo "FAIL: cannot resolve this script's directory" >&2; exit 1; }
PAYLOAD="$SRC/pro"
EXCLUDE="$SRC/payload-exclude.txt"

DRY=no
case "${1:-}" in
  --dry-run) DRY=yes; shift ;;
esac
DEST="${1:-}"

die() { echo "FAIL: $*" >&2; exit 1; }
ok()  { echo "ok:   $*"; }

[ -n "$DEST" ] || die "usage: sh sync-dist.sh [--dry-run] /path/to/startupboardskills-checkout"

# ---------------------------------------------------------------- step 0: shape
[ -d "$PAYLOAD" ] || die "$PAYLOAD missing — run this from the dev checkout root"
[ -r "$EXCLUDE" ] || die "$EXCLUDE missing — the builder and the guard both read it, and so does this script"
DEST="$(cd "$DEST" 2>/dev/null && pwd)" || die "destination does not exist: ${1:-}"
[ -d "$DEST/.git" ] || die "$DEST is not a git checkout"
ok "source $SRC"
ok "destination $DEST"

# ------------------------------------------------- step 1: refuse a dirty tree
# Either side. A sync from a dirty source ships uncommitted work; a sync into a
# dirty destination buries someone else's changes in the diff.
[ -z "$(git -C "$SRC" status --porcelain)" ] || die "source tree is dirty — commit or stash first, so the sync traces to a commit"
ok "source clean at $(git -C "$SRC" rev-parse --short HEAD)"
[ -z "$(git -C "$DEST" status --porcelain)" ] || die "destination tree is dirty — this stages a diff for review and will not mix it with existing changes"
ok "destination clean at $(git -C "$DEST" rev-parse --short HEAD)"

# ------------------------------------------------- step 2: refuse a red suite
# The shipped copy is worth syncing only if what it copies passes. The zip group
# is included deliberately: a stale archive means the dev tree has edits that
# were never built, and syncing those gives a buyer a skill whose own tests
# describe a different version.
echo "running the full suite before syncing..."
_log="${TMPDIR:-/tmp}/sync-suite.$$"
sh "$PAYLOAD/evals/check.sh" all >"$_log" 2>&1 || {
  tail -20 "$_log" >&2
  rm -f "$_log"
  die "suite is not green — fix it or rebuild the archive before syncing"
}
ok "suite PASS ($(grep -c '^ok:' "$_log") assertions)"
rm -f "$_log"

# ------------------------------------------- step 3: build the shipped file list
# The same exclusion list the builder and the guard read. Three readers, one
# file: that is the point. A path excluded from the archive is excluded here.
SHIP_LIST="${TMPDIR:-/tmp}/sync-ship.$$"
( cd "$PAYLOAD" && find . -type f | sed 's|^\./||' | LC_ALL=C sort ) | while IFS= read -r f; do
  _skip=0
  while IFS= read -r pat; do
    [ -z "$pat" ] && continue
    case "$pat" in \#*) continue ;; esac
    case "$f" in $pat) _skip=1; break ;; esac
  done < "$EXCLUDE"
  [ "$_skip" = 0 ] && printf '%s\n' "$f"
done > "$SHIP_LIST"
COUNT=$(grep -c . "$SHIP_LIST" || true)
[ "$COUNT" -gt 0 ] || die "the exclusion list excluded everything — check $EXCLUDE"
ok "$COUNT files to ship"

# --------------------------------------------------- step 4: stage into DEST
# Layout, per the ruling of 2026-10-13:
#   <dest>/.claude-plugin/marketplace.json   manifest at the DISTRIBUTION root,
#                                            never inside the payload: shipping
#                                            it to buyers pointing at a repo
#                                            they cannot read was the first bug
#   <dest>/skills/startup-board-pro/...      where the plugin protocol looks
SKILLDIR="$DEST/skills/startup-board-pro"
if [ "$DRY" = yes ]; then
  echo "--- dry run: would stage $COUNT files into $SKILLDIR"
  head -5 "$SHIP_LIST" | sed 's/^/      /'
  echo "      ... and $((COUNT - 5)) more"
else
  rm -rf "$SKILLDIR" || die "cannot clear $SKILLDIR"
  while IFS= read -r f; do
    mkdir -p "$SKILLDIR/$(dirname "$f")" || die "cannot create $SKILLDIR/$(dirname "$f")"
    cp "$PAYLOAD/$f" "$SKILLDIR/$f" || die "cannot copy $f"
  done < "$SHIP_LIST"
  ok "staged $COUNT files into skills/startup-board-pro/"
fi

# ---------------------------- step 5: assert the shipped copy is byte-identical
# The assertion the deleted distribution repo could never make about itself.
if [ "$DRY" = no ]; then
  _diffs=0
  while IFS= read -r f; do
    cmp -s "$PAYLOAD/$f" "$SKILLDIR/$f" || { echo "DIFFERS: $f" >&2; _diffs=$((_diffs + 1)); }
  done < "$SHIP_LIST"
  [ "$_diffs" = 0 ] || die "$_diffs shipped files differ from pro/ — the sync did not land cleanly"
  ok "all $COUNT shipped files byte-identical to pro/"

  # And nothing extra: a destination file absent from the list is a leftover
  # from an earlier layout, and leftovers are how AUDIT.md once shipped.
  _extra=$( ( cd "$SKILLDIR" && find . -type f | sed 's|^\./||' | LC_ALL=C sort ) | comm -23 - "$SHIP_LIST" )
  [ -z "$_extra" ] || { printf '%s\n' "$_extra" >&2; die "destination holds files not in the ship list"; }
  ok "no extra files in the destination"
fi

# ------------------------------------------- step 6: manifest at the dest root
[ -f "$DEST/.claude-plugin/marketplace.json" ] \
  || echo "WARN: $DEST/.claude-plugin/marketplace.json is missing — the plugin route needs the manifest at the distribution root, not inside skills/. Create it before the first /plugin marketplace add." >&2
if [ -f "$SKILLDIR/.claude-plugin/marketplace.json" ]; then
  die "marketplace.json found INSIDE the payload at $SKILLDIR/.claude-plugin/ — the bug that shipped a dead repo URL to buyers. Keep it only at the distribution root."
fi
ok "no marketplace.json inside the payload"

rm -f "$SHIP_LIST"

# ----------------------------------------------------------------- step 7: stop
echo
echo "Staged, not committed. Review and commit by hand:"
echo "    git -C \"$DEST\" status"
echo "    git -C \"$DEST\" add -A skills/startup-board-pro"
echo "    git -C \"$DEST\" commit -m \"sync skill from dev $(git -C "$SRC" rev-parse --short HEAD)\""
echo
echo "This script does not commit, push, create releases or add collaborators."
echo "The archive and its published SHA-256 are a separate step: the checksum"
echo "belongs to one built file, and rebuilding voids it."
