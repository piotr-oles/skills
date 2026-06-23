#!/usr/bin/env bash
set -euo pipefail

FORCE=0
for arg in "$@"; do
  [[ "$arg" == "--force" ]] && FORCE=1
done

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SKILLS_SRC="$REPO_DIR/skills/engineering"
SKILLS_DST="$HOME/.agents/skills"

SUBAGENTS_SRC="$REPO_DIR/subagents"
SUBAGENTS_DST="$HOME/.pi/agent/subagents"

pretty() { echo "$1" | sed "s|^$HOME|~|"; }

link() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      echo "  skip   $(pretty "$dst") (already linked)"
      return
    fi
    echo "  update $(pretty "$dst")"
    ln -sf "$src" "$dst"
  elif [[ -e "$dst" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      echo "  force  $(pretty "$dst")"
      rm -rf "$dst"
      ln -s "$src" "$dst"
    else
      echo "  WARN   $(pretty "$dst") exists and is not a symlink — skipping (use --force to replace)"
    fi
  else
    echo "  link   $(pretty "$dst") -> $(pretty "$src")"
    ln -s "$src" "$dst"
  fi
}

echo "==> skills: $(pretty "$SKILLS_SRC") -> $(pretty "$SKILLS_DST")"
mkdir -p "$SKILLS_DST"
for src in "$SKILLS_SRC"/*/; do
  name="$(basename "$src")"
  link "$src" "$SKILLS_DST/$name"
done
while IFS= read -r entry; do
  name="$(basename "$entry")"
  [[ -d "$SKILLS_SRC/$name" ]] && continue
  echo "  external  $name"
done < <(find "$SKILLS_DST" -maxdepth 1 -mindepth 1 -type d 2>/dev/null || true)

echo "==> subagents: $(pretty "$SUBAGENTS_SRC") -> $(pretty "$SUBAGENTS_DST")"
mkdir -p "$SUBAGENTS_DST"
for src in "$SUBAGENTS_SRC"/*.md; do
  [[ "$(basename "$src")" == "README.md" ]] && continue
  name="$(basename "$src")"
  link "$src" "$SUBAGENTS_DST/$name"
done
while IFS= read -r entry; do
  name="$(basename "$entry")"
  [[ "$name" == "README.md" ]] && continue
  [[ -f "$SUBAGENTS_SRC/$name" ]] && continue
  echo "  external  $name"
done < <(find "$SUBAGENTS_DST" -maxdepth 1 -mindepth 1 -name '*.md' 2>/dev/null || true)

echo "done"
