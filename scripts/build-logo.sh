#!/bin/sh
# SPDX-License-Identifier: MIT
set -eu

base=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
output=${1:-"$base/build/logo.icns"}
mkdir -p "$(dirname -- "$output")"
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT HUP INT TERM
iconset="$temporary/logo.iconset"
mkdir "$iconset"

for size in 16 32 128 256 512; do
    rsvg-convert -w "$size" -h "$size" "$base/assets/hikari-linux.svg" \
        -o "$iconset/icon_${size}x${size}.png"
    rsvg-convert -w "$((size * 2))" -h "$((size * 2))" "$base/assets/hikari-linux.svg" \
        -o "$iconset/icon_${size}x${size}@2x.png"
done

if command -v iconutil >/dev/null 2>&1; then
    iconutil -c icns "$iconset" -o "$output"
elif command -v png2icns >/dev/null 2>&1; then
    png2icns "$output" "$iconset/icon_16x16.png" "$iconset/icon_32x32.png" \
        "$iconset/icon_128x128.png" "$iconset/icon_256x256.png" \
        "$iconset/icon_512x512.png" "$iconset/icon_512x512@2x.png"
else
    echo "Install iconutil (macOS) or icnsutils to build the installer icon." >&2
    exit 1
fi
