#!/bin/bash
# Convert a party icon sheet (two frames stacked) into a 32x48 Pokewalker icon (two 32x24 frames stacked).
# The output is an 8-bit grayscale PNG using exactly four levels (255, 168, 80, 0); ENCODE_IMG maps them to the 2-bit values.

set -euo pipefail

INPUT_SPRITE="${1:-}"
OUTPUT_SPRITE="${2:-}"

if [ -z "$INPUT_SPRITE" ] || [ -z "$OUTPUT_SPRITE" ]; then
    echo "Usage: $0 input.png output.png"
    exit 1
fi

IM=convert
command -v magick > /dev/null && IM=magick

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# 1. Physical 4-color palette (same colors DECODE_IMG writes)
$IM -size 1x1 xc:#FFFFFF xc:#A8A8A8 xc:#505050 xc:#000000 +append "$TMP_DIR/pal.png"

# 2. Get the dimensions dynamically from the input sheet
WIDTH=$(identify -format "%w" "$INPUT_SPRITE" 2> /dev/null | head -n 1 || true)
HEIGHT=$(identify -format "%h" "$INPUT_SPRITE" 2> /dev/null | head -n 1 || true)

if [ -z "$WIDTH" ] || [ -z "$HEIGHT" ]; then
    echo "Error: ImageMagick cannot read the dimensions of $INPUT_SPRITE."
    exit 1
fi

# Party icons are stacked vertically, so each frame is half the total height
HALF_HEIGHT=$((HEIGHT / 2))

# 3. Process each frame (bottom 24 rows of its half).
# -fuzz 5% handles minor color variants in the teal background
# -fill "#FFFFFF" -opaque "#609880" converts the teal to white BEFORE grayscaling
for FRAME in 1 2; do
    Y_OFFSET=$((FRAME * HALF_HEIGHT - 24))
    $IM "$INPUT_SPRITE" -crop "${WIDTH}x24+0+${Y_OFFSET}" +repage \
        -fuzz 5% -fill "#FFFFFF" -opaque "#609880" \
        -background "#FFFFFF" -alpha remove -alpha off \
        -modulate 100,150,100 \
        -level 5%,95% \
        -colorspace gray \
        +dither -remap "$TMP_DIR/pal.png" \
        "$TMP_DIR/f$FRAME.png"
done

# 4. Stack the frames into a 32x48 sheet
$IM "$TMP_DIR/f1.png" "$TMP_DIR/f2.png" -append \
    -colorspace gray -depth 8 -define png:color-type=0 PNG:"$OUTPUT_SPRITE"

echo "Pokewalker icon saved to $OUTPUT_SPRITE"
