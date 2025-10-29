#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------
# Record cbonsai and export only the final frame as SVG
# -----------------------------------------

CAST_V3="${1:-cbonsai_v3.cast}"
CAST_V2="${2:-cbonsai_v2.cast}"
SVG_OUT="${3:-cbonsai_final.svg}"

# Add a small idle tail so the final frame is fully settled
echo "🎥 Recording cbonsai (auto-exit with -p)..."
asciinema rec --overwrite "$CAST_V3" \
  -c 'bash -lc "cbonsai -p; sleep 0.2"'

echo "🔄 Converting to asciicast v2 format..."
asciinema convert -f asciicast-v2 "$CAST_V3" "$CAST_V2" --overwrite

echo "🧮 Finding end timestamp (+epsilon) in ms..."
# Take the maximum timestamp across ALL events (output, resize, etc.)
# Convert sec -> ms and add a tiny epsilon to ensure we render *after* the last event.
LAST_MS="$(
  jq -s '
    # Collect all event times (skip header)
    ([ .[1:][] | select(type=="array") | .[0] ] | max) as $t
    | if ($t == null) then 0 else ($t * 1000 | floor) end
  ' "$CAST_V2"
)"
# Add epsilon (100 ms) to be safely beyond the last event
AT_MS=$(( LAST_MS + 100 ))

echo "🌿 Generating SVG from final frame at ${AT_MS} ms..."
npx svg-term \
  --in "$CAST_V2" \
  --out "$SVG_OUT" \
  --window \
  --no-cursor \
  --at "$AT_MS"

echo "✅ Done! Final frame saved to: $SVG_OUT"
