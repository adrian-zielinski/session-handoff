#!/usr/bin/env bash
# Session Handoff — installer
# Copies the skill and the two slash commands into your Claude Code config.
#
#   ./install.sh              install for all projects  (~/.claude)
#   ./install.sh --project    install for this project only  (./.claude)
#   ./install.sh --uninstall  remove the installed files

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.claude"
SCOPE="global (~/.claude)"
MODE="install"

for arg in "$@"; do
  case "$arg" in
    --project) TARGET="$PWD/.claude"; SCOPE="project ($PWD/.claude)" ;;
    --uninstall) MODE="uninstall" ;;
    -h|--help) sed -n '2,8p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

FILES=(
  "skills/session-handoff/SKILL.md"
  "commands/handoff.md"
  "commands/pickup.md"
)

if [ "$MODE" = "uninstall" ]; then
  echo "Removing Session Handoff from $SCOPE"
  rm -f "$TARGET/commands/handoff.md" "$TARGET/commands/pickup.md"
  rm -rf "$TARGET/skills/session-handoff"
  echo "Done. Restart Claude Code to drop it from the session."
  exit 0
fi

echo "Installing Session Handoff into $SCOPE"

for f in "${FILES[@]}"; do
  [ -f "$SRC/$f" ] || { echo "Missing source file: $SRC/$f" >&2; exit 1; }
  dest="$TARGET/$f"
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ] && ! cmp -s "$SRC/$f" "$dest"; then
    cp "$dest" "$dest.bak"
    echo "  backed up existing $f -> $f.bak"
  fi
  cp "$SRC/$f" "$dest"
  echo "  installed $f"
done

cat <<'EOF'

Installed. Start a new Claude Code session, then:

  /handoff          save this session's context to a topic file
  /pickup           resume a topic from a previous session

Everything lands in a HANDOFF/ folder at your project root. Commit it.
EOF
