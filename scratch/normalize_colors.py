#!/usr/bin/env python3

import re
import sys
from pathlib import Path

# Input and output files
input_file = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("bonsai_raw.tex")
output_file = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("bonsai.tex")

# Read LaTeX fragment
with input_file.open("r") as f:
    content = f.read()

# Match \color[rgb]{r,g,b} with optional spaces
pattern = r"\\color\[rgb\]\{\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,\s*([0-9.]+)\s*\}"
matches = list(dict.fromkeys(re.findall(pattern, content)))  # unique, keep order

if not matches:
    print("⚠️  No RGB colors detected in input file.")
else:
    print(f"🎨 Detected {len(matches)} unique RGB color(s):\n")

# Replace with symbolic colors and report
for i, rgb in enumerate(matches, start=1):
    r, g, b = rgb
    old_pattern = fr"\\color[rgb]{{{r},{g},{b}}}"
    flexible = re.compile(
        rf"\\color\[rgb\]\{{\s*{r}\s*,\s*{g}\s*,\s*{b}\s*\}}"
    )
    count = len(flexible.findall(content))
    content = flexible.sub(fr"\\color{{c{i}}}", content)

    print(f"  c{i:<2} ← rgb({r}, {g}, {b})  [{count} occurrence(s)]")

# Write cleaned file
with output_file.open("w") as f:
    f.write(content)

# Print color definitions
print("\n% Color definitions for bonsai.tex")
for i, (r, g, b) in enumerate(matches, start=1):
    r_html = int(float(r) * 255)
    g_html = int(float(g) * 255)
    b_html = int(float(b) * 255)
    print(fr"\definecolor{{c{i}}}{{RGB}}{{{r_html},{g_html},{b_html}}}")

print(f"\n✅ Normalized colors written to {output_file}")
