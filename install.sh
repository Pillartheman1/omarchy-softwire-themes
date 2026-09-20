#!/usr/bin/env bash
# Install all Softwire Omarchy themes in one shot.
set -euo pipefail

REPO_URL="${SOFTWIRE_REPO_URL:-https://github.com/Pillartheman1/omarchy-softwire-themes.git}"
THEMES_DIR="${HOME}/.config/omarchy/themes"
THEMES=(softwire-black softwire-blue softwire-green softwire-red softwire-white)
CLEANUP=""

script_dir=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [[ -n "$script_dir" && -d "$script_dir/themes/softwire-black" ]]; then
  SRC="$script_dir/themes"
else
  if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required to install Softwire themes." >&2
    exit 1
  fi
  CLEANUP="$(mktemp -d)"
  echo "Cloning ${REPO_URL}..."
  git clone --depth 1 -- "$REPO_URL" "$CLEANUP"
  SRC="$CLEANUP/themes"
fi

mkdir -p "$THEMES_DIR"

copy_theme() {
  local src="$1" dest="$2"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete --exclude '.git' --exclude '*.bak' --exclude '*.bak.*' "$src/" "$dest/"
  else
    rm -rf "$dest"
    mkdir -p "$dest"
    cp -a "$src"/. "$dest"/
  fi
}

for theme in "${THEMES[@]}"; do
  if [[ ! -d "$SRC/$theme" ]]; then
    echo "Error: missing theme '$theme' in $SRC" >&2
    exit 1
  fi
  echo "Installing ${theme}..."
  copy_theme "$SRC/$theme" "$THEMES_DIR/$theme"
done

if [[ -n "$CLEANUP" ]]; then
  rm -rf "$CLEANUP"
fi

echo
echo "Installed Softwire Black, Blue, Green, Red, and White."
echo "Switch with:"
echo "  omarchy theme set \"Softwire Black\""
echo "  omarchy theme set \"Softwire Blue\""
echo "  omarchy theme set \"Softwire Green\""
echo "  omarchy theme set \"Softwire Red\""
echo "  omarchy theme set \"Softwire White\""

if command -v omarchy >/dev/null 2>&1; then
  current="$(omarchy theme current 2>/dev/null || true)"
  case "$current" in
    "Softwire Black"|"Softwire Blue"|"Softwire Green"|"Softwire Red"|"Softwire White")
      echo
      echo "Re-applying ${current} so the installed files take effect..."
      omarchy theme set "$current"
      ;;
  esac
fi
