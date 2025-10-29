# 🌲 Bonsai → LaTeX Workflow

This project generates an ANSI-colored bonsai tree using  
[`cbonsai`](https://gitlab.com/jallbrit/cbonsai), converts it into a LaTeX  
fragment, and normalizes the colors for clean and reusable rendering.

---

## 🧩 Overview

1. **Generate** a bonsai tree with customizable life cycles and colors.  
2. **Convert** the ANSI output to LaTeX using `ansifilter`.  
3. **Normalize** colors with a Python script that replaces inline RGB codes  
   (e.g. `\color[rgb]{...}`) with symbolic names (`\color{c1}`, `\color{c2}`, …).  
4. **Print** LaTeX color definitions for easy inclusion in your preamble.

---

## ⚙️ Usage

Run the main script:

    ./generate_bonsai.sh

This will:
- Run `cbonsai` for a fixed number of life cycles (`life=32`).
- Keep the last few lines to capture the final tree.
- Convert the ANSI output to LaTeX (`bonsai_raw.tex`).
- Replace all explicit RGB colors with symbolic names and produce:
  - `bonsai.tex` — the cleaned LaTeX fragment.
  - A list of `\definecolor` commands printed in the terminal.

---

## 🐍 Python normalization

The helper script `normalize_colors.py`:
- Detects all unique RGB color definitions in the LaTeX fragment.  
- Replaces them with symbolic names (`c1`, `c2`, …).  
- Prints the matching LaTeX color definitions in RGB and HTML hex.

Example output:

    🎨 Detected 4 unique RGB colors:
      c1 ← rgb(0.88, 0.87, 0.96)
      c2 ← rgb(0.36, 0.36, 1)
      c3 ← rgb(0, 0.8, 0)
      c4 ← rgb(0.8, 0, 0)

    % Color definitions for bonsai.tex
    \definecolor{c1}{HTML}{e0def4}
    \definecolor{c2}{HTML}{9ccfd8}
    \definecolor{c3}{HTML}{31748f}
    \definecolor{c4}{HTML}{eb6f92}

---

## 📄 Integration in LaTeX

In your document preamble:

    \usepackage{xcolor}
    \definecolor{c1}{HTML}{e0def4}
    \definecolor{c2}{HTML}{9ccfd8}
    \definecolor{c3}{HTML}{31748f}
    \definecolor{c4}{HTML}{eb6f92}

Include the bonsai:

    \ttfamily
    \input{bonsai.tex}

---

## 🧠 Dependencies

Install dependencies on Arch Linux:

    sudo pacman -S cbonsai ansifilter python

Optional (for LaTeX compilation):

    sudo pacman -S texlive-core texlive-latexextra

---

## 🌸 Notes

- You can later map the symbolic colors to a specific palette  
  (e.g., Rose Pine, Catppuccin, or custom ANSI schemes).  
- The process is deterministic: same color indices produce the same look.  
- Ideal for embedding styled terminal art into LaTeX papers or slides.

---

© Martin Roa-Villescas
