#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOURCE="$PLUGIN_DIR/assets/source/oligarchy.txt"
OUTPUT="$PLUGIN_DIR/assets/generated/oligarchy-wordmark.png"
TEMP="$(mktemp --suffix=.png)"
trap 'rm -f "$TEMP"' EXIT

command -v magick >/dev/null || { echo "ImageMagick (magick) is required." >&2; exit 1; }
FONT="$(fc-match -f '%{file}\n' 'JetBrains Mono Nerd Font' | sed -n '1p')"
[[ -f "$FONT" ]] || { echo "JetBrains Mono Nerd Font was not found via fc-match." >&2; exit 1; }

magick -background none -fill white -font "$FONT" -pointsize 72 label:@"$SOURCE" "$TEMP"
magick "$TEMP" -define png:exclude-chunk=date,time -trim +repage "$OUTPUT"
identify "$OUTPUT"
