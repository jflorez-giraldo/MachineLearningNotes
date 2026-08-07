#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$PROJECT_DIR/notebooks"

for ch in 03 04 05 06
do
    quarto convert \
        "$PROJECT_DIR/chapters/chapter${ch}.qmd" \
        --output "$PROJECT_DIR/notebooks/chapter${ch}.ipynb"
done

echo "Done."