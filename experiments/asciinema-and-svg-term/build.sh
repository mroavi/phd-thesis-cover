#!/usr/bin/env bash

# Record cbonsai while it's being printed
asciinema rec cbonsai_v3.cast \
  --command "bash -lc 'cbonsai -p; sleep 3'" \
  --overwrite \
  --quiet

# Convert to asciicast v2 format
asciinema convert \
  --overwrite \
  -f asciicast-v2 cbonsai_v3.cast cbonsai_v2.cast

# Render to SVG
npx svg-term \
  --in cbonsai_v2.cast \
  --out cbonsai_final.svg \
  --window \
  --no-cursor
