#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------
# Record cbonsai and export only the final frame as SVG
# -----------------------------------------

CAST_V3="${1:-cbonsai_v3.cast}"
CAST_V2="${2:-cbonsai_v2.cast}"
SVG_OUT="${3:-cbonsai_final.svg}"

echo "🎥 Recording cbonsai (auto-exit with -p)..."
asciinema rec --overwrite "$CAST_V3" -c "cbonsai -p"

echo "🔄 Converting to asciicast v2 format..."
asciinema convert -f asciicast-v2 "$CAST_V3" "$CAST_V2" --overwrite

echo "🧮 Finding timestamp (ms) of the last output event..."
# asciicast v2 events look like: [time_seconds, "o"|"output", "data"]
# We take the *last* such event and convert seconds -> ms.
LAST_MS="$(
  jq -s '
    [ .[1:][] | select(type=="array" and (.[1]=="o" or .[1]=="output")) ]
    | last
    | if . == null then 0 else (.[0] * 1000 | floor) end
  ' "$CAST_V2"
)"

echo "🌿 Generating SVG from final frame at ${LAST_MS} ms..."
npx svg-term \
  --in "$CAST_V2" \
  --out "$SVG_OUT" \
  --window \
  --no-cursor \
  --at "$LAST_MS"

echo "✅ Done! Final frame saved to: $SVG_OUT"
