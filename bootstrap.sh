#!/usr/bin/env bash
# Instantiate a project workspace from this blueprint. Idempotent — safe to re-run.
# Usage: bash bootstrap.sh <project-dir>
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${1:?usage: bash bootstrap.sh <project-dir>}"
mkdir -p "$DEST"
DEST="$(cd "$DEST" && pwd)"

# committed structure + personal scratch
mkdir -p "$DEST"/{docs,specs,plans,journal,_work/kits,_work/kit-archive}

# project AGENTS.md from template (never overwrite an existing one)
[ -f "$DEST/AGENTS.md" ] || cp "$HERE/template/AGENTS.md" "$DEST/AGENTS.md"

# journal README
[ -f "$DEST/journal/README.md" ] || printf '# Journal\n\nOne short entry per PR, newest first.\n' > "$DEST/journal/README.md"

# task-kit symlink (relative; default assumes the sibling layout .../<owner>/ + michaelstingl/task-kit)
LINK="$DEST/_work/task-kit"
if [ ! -e "$LINK" ]; then
  ln -s ../../michaelstingl/task-kit "$LINK"
  if [ -e "$LINK/board.ts" ]; then
    echo "  ✓ _work/task-kit -> ../../michaelstingl/task-kit"
  else
    rm -f "$LINK"
    echo "  ! couldn't resolve task-kit from this layout — link it manually:"
    echo "      ln -s <relative-path-to>/michaelstingl/task-kit $LINK"
  fi
fi

# pre-commit secret/internal-ref guard
[ -f "$DEST/.git-deny-patterns" ] || cp "$HERE/.git-deny-patterns.example" "$DEST/.git-deny-patterns"
# the real denylist lists internal names → keep it out of git
grep -qxF '.git-deny-patterns' "$DEST/.gitignore" 2>/dev/null || printf '.git-deny-patterns\n' >> "$DEST/.gitignore"
if [ -d "$DEST/.git" ]; then
  cp "$HERE/hooks/pre-commit" "$DEST/.git/hooks/pre-commit" && chmod +x "$DEST/.git/hooks/pre-commit"
  echo "  ✓ installed .git/hooks/pre-commit (secret guard)"
else
  echo "  ! no .git yet — after 'git init', run: cp \"$HERE/hooks/pre-commit\" .git/hooks/ && chmod +x .git/hooks/pre-commit"
fi

echo "✓ workspace scaffolded at $DEST"
echo "  next: edit AGENTS.md, then create a kit: bun _work/task-kit/new-kit.ts <slug> --title \"…\""
