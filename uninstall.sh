#!/usr/bin/env bash
# Remove all Softwire Omarchy themes in one shot.
set -euo pipefail

THEMES_DIR="${HOME}/.config/omarchy/themes"
BACKGROUNDS_DIR="${HOME}/.config/omarchy/backgrounds"
THEMES=(softwire-black softwire-blue softwire-green softwire-red softwire-white)

is_softwire_current() {
  case "${1:-}" in
    "Softwire Black"|"Softwire Blue"|"Softwire Green"|"Softwire Red"|"Softwire White"|softwire-black|softwire-blue|softwire-green|softwire-red|softwire-white)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if command -v omarchy >/dev/null 2>&1; then
  current="$(omarchy theme current 2>/dev/null || true)"
  if is_softwire_current "$current"; then
    echo "Currently on ${current}; switching to a stock theme first..."
    if ! omarchy theme set catppuccin 2>/dev/null; then
      omarchy theme set tokyo-night
    fi
  fi
fi

removed=0
for theme in "${THEMES[@]}"; do
  dest="$THEMES_DIR/$theme"
  if [[ -d "$dest" ]]; then
    echo "Removing ${theme}..."
    rm -rf "$dest"
    removed=$((removed + 1))
  else
    echo "Skipping ${theme} (not installed)."
  fi
  extra="$BACKGROUNDS_DIR/$theme"
  if [[ -d "$extra" ]]; then
    rm -rf "$extra"
  fi
done

if (( removed == 0 )); then
  echo "No Softwire themes were installed."
  exit 0
fi

echo
echo "Removed Softwire Black, Blue, Green, Red, and White."
