#!/bin/bash

# Number of life cycles for the tree
life=32

# Bonsai generation command with life parameter
cmd="cbonsai -p -s 1 -M 1 -L $life -k 1,2,3,4"

# Run the command and keep only the last $life lines
eval "$cmd" | tail -n 28 > bonsai.ans

# Convert the ANSI output to a LaTeX fragment
ansifilter --latex --wrap=0 --fragment -i bonsai.ans -o bonsai_raw.tex

# Normalize colors using Python
./normalize_colors.py bonsai_raw.tex bonsai.tex

echo "✅ Generated bonsai.tex and printed matching color definitions."
