#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$PROJECT_DIR/notebooks"

for ch in 02 03 04 05 06 07 08 09 10
do
    notebook="$PROJECT_DIR/notebooks/chapter${ch}.ipynb"
    quarto convert \
        "$PROJECT_DIR/chapters/chapter${ch}.qmd" \
        --output "$notebook"

    if command -v jq >/dev/null 2>&1; then
        cleaned_notebook="$(mktemp)"
        jq 'del(.metadata.kernelspec.path)' "$notebook" > "$cleaned_notebook"
        mv "$cleaned_notebook" "$notebook"
    fi
done

echo "Done."
