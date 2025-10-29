#!/usr/bin/env bash

BONSAI_CMD="cbonsai -s 92 -l -t 0.001"

# Record cbonsai inside a pseudo-terminal with a larger TTY
script -qec \
  "stty rows 24 cols 50; \
   asciinema rec cbonsai_v3.cast \
     --command '${BONSAI_CMD}' \
     --overwrite \
     --quiet" \
  /dev/null

# Convert to asciicast v2 format
asciinema convert \
  --overwrite \
  -f asciicast-v2 cbonsai_v3.cast cbonsai_v2.cast

# Render to SVG
npx svg-term \
  --in cbonsai_v2.cast \
  --out cbonsai_final.svg \
  --no-cursor \
  --at 300
