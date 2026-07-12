#!/usr/bin/env bash
# Instantiate / update a project workspace from this blueprint. Idempotent — safe to re-run.
#
# Usage: bash bootstrap.sh [--link] <project-dir>
#   default : CLONE task-kit + workspace-blueprint into <project>/_work (update later via git pull)
#   --link  : SYMLINK them to sibling clones instead (for active co-development of the tools)
#
# Project content (docs/specs/plans/journal, AGENTS.md) is committed; everything under _work/
# is personal and gitignored (the cloned tools + your kits live there).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LINK_MODE=0; ARGS=()
for a in "$@"; do case "$a" in --link) LINK_MODE=1 ;; *) ARGS+=("$a") ;; esac; done
DEST="${ARGS[0]:?usage: bash bootstrap.sh [--link] <project-dir>}"
mkdir -p "$DEST"; DEST="$(cd "$DEST" && pwd)"

# committed structure + personal scratch
mkdir -p "$DEST"/{docs,specs,plans,journal,_work/kits,_work/kit-archive}
[ -f "$DEST/AGENTS.md" ] || cp "$HERE/template/AGENTS.md" "$DEST/AGENTS.md"
# CLAUDE.md -> AGENTS.md so a harness that auto-loads CLAUDE.md still sees the routing head.
# Skip if the project already has its own CLAUDE.md (do not clobber it).
[ -e "$DEST/CLAUDE.md" ] || { ln -s AGENTS.md "$DEST/CLAUDE.md" && echo "  ✓ CLAUDE.md -> AGENTS.md (routing head auto-loads)"; }
[ -f "$DEST/journal/README.md" ] || printf '# Journal\n\nOne short entry per PR, newest first.\n' > "$DEST/journal/README.md"

# _work is personal — never tracked
grep -qxF '_work/' "$DEST/.gitignore" 2>/dev/null || printf '_work/\n' >> "$DEST/.gitignore"

# --- consume the tools: clone into _work (default) or symlink (--link, for co-dev) ---
ensure_dep() {  # $1=name  $2=clone-url  $3=symlink-target
  local dir="$DEST/_work/$1"
  if [ "$LINK_MODE" = 1 ]; then
    [ -e "$dir" ] || { ln -s "$3" "$dir" && echo "  ✓ linked _work/$1 -> $3"; }
  elif [ -d "$dir/.git" ]; then
    ( git -C "$dir" pull --ff-only -q && echo "  ✓ updated _work/$1" ) || echo "  ! _work/$1 pull skipped"
  elif [ -e "$dir" ]; then
    echo "  ! _work/$1 exists but is not a git clone — leaving it"
  else
    ( git clone -q "$2" "$dir" && echo "  ✓ cloned _work/$1" ) || echo "  ! clone failed: $1"
  fi
}
ensure_dep task-kit            "https://github.com/michaelstingl/task-kit"            "../../michaelstingl/task-kit"
ensure_dep workspace-blueprint "https://github.com/michaelstingl/workspace-blueprint" "../../michaelstingl/workspace-blueprint"

# stamp the blueprint version this project was set up / refreshed with (drift visibility; gitignored)
( cd "$HERE" && git describe --tags --always 2>/dev/null ) > "$DEST/_work/.workspace-blueprint-version" 2>/dev/null || true

# --- pre-commit secret / internal-ref guard ---
[ -f "$DEST/.git-deny-patterns" ] || cp "$HERE/.git-deny-patterns.example" "$DEST/.git-deny-patterns"
grep -qxF '.git-deny-patterns' "$DEST/.gitignore" 2>/dev/null || printf '.git-deny-patterns\n' >> "$DEST/.gitignore"
mkdir -p "$DEST/hooks" && cp "$HERE/hooks/pre-commit" "$DEST/hooks/pre-commit" && chmod +x "$DEST/hooks/pre-commit"
if command -v lefthook >/dev/null 2>&1 && command -v gitleaks >/dev/null 2>&1; then
  cp "$HERE/lefthook.yml" "$DEST/lefthook.yml"
  ( cd "$DEST" && lefthook install >/dev/null 2>&1 ) && echo "  ✓ gate: lefthook + gitleaks + internal-ref denylist"
elif [ -d "$DEST/.git" ]; then
  cp "$HERE/hooks/pre-commit" "$DEST/.git/hooks/pre-commit" && chmod +x "$DEST/.git/hooks/pre-commit"
  echo "  ✓ gate: zero-dep fallback .git/hooks/pre-commit  (stronger: brew install lefthook gitleaks)"
else
  echo "  ! no .git yet — install the gate after 'git init' (lefthook install, or cp hooks/pre-commit .git/hooks/)"
fi

echo "✓ workspace ready at $DEST"
echo "  update later:  git -C _work/task-kit pull && git -C _work/workspace-blueprint pull   (then re-run bootstrap)"
echo "  create a kit:  bun _work/task-kit/new-kit.ts <slug> --title \"…\""
