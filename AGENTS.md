# Repository Guide

## Sources And Generated Files

- Edit chapter sources in `chapters/chapterNN.qmd`; `notebooks/chapterNN.ipynb` are versioned exports, not the authoring source.
- After changing chapters 02-10, run `bash scripts/build_notebooks.sh` and include the matching notebook changes. The HTML `{{< chapter-actions >}}` shortcode links each chapter to `notebooks/<chapter-stem>.ipynb`.
- `_freeze/` is versioned and is required for publication; `_book/` is ignored build output. Commit regenerated HTML and PDF freeze data/figures for executed chapter changes, and remove obsolete frozen figures when cells or labels disappear.
- `scripts/build_book.sh` and `scripts/publish.sh` are empty; do not infer workflows from their names.

## Local Runtime

- Python is pinned by `.python-version` to 3.11.15; dependencies are in `requirements.txt`. The repository-local `.python/`, `.venv/`, and `.tmp/` are ignored and must remain local.
- Chapter front matter uses `jupyter: python3`. Putting `.venv/bin` first in `PATH` does not guarantee Quarto selects that interpreter: verify with `./.venv/bin/jupyter kernelspec list`. The `python3` kernelspec must resolve to this repository's `.venv/bin/python`, not a user/global Python.
- Keep caches and Jupyter runtime files inside the repository when executing:

```bash
PATH="$PWD/.venv/bin:$PATH" \
JUPYTER_PATH="$PWD/.venv/share/jupyter" \
XDG_CACHE_HOME="$PWD/.tmp/xdg-cache" \
MPLCONFIGDIR="$PWD/.tmp/matplotlib" \
JUPYTER_CONFIG_DIR="$PWD/.tmp/jupyter-config" \
JUPYTER_DATA_DIR="$PWD/.tmp/jupyter-data" \
JUPYTER_RUNTIME_DIR="$PWD/.tmp/jupyter-runtime" \
quarto render
```

- Do not hide numerical warnings globally: `_quarto.yml` intentionally has `warning: true`. Fix or classify warnings and inspect regenerated `_freeze/.../execute-results/*.json`.

## Rendering And Verification

- `_quarto.yml` defines a single Quarto book with HTML and PDF outputs, `freeze: auto`, and project-root execution. A normal project render can traverse all 14 documents; `quarto render --execute` forces broad re-execution and must not be used for a chapter-only change.
- For one changed chapter, use `quarto render chapters/chapterNN.qmd --to html --use-freezer`. This executes/renders only that file and updates its HTML freeze. The analogous PDF command updates its TeX freeze and PDF figures but may fail afterward when Quarto attempts to assemble the complete book; verify PDF with a standalone temporary project under `.tmp/` instead of rendering the root project.
- GitHub Pages runs `quarto render --profile ci --use-freezer` without installing Python dependencies, so publication depends on committed frozen results. Verified with Quarto 1.9.38: `--profile ci` still resolves `freeze: auto`; `.github/workflows/_quarto-ci.yml` is not loaded as a Quarto profile from that location, and `--use-freezer` explicitly prevents re-execution.
- Focused checks after an executed chapter change:

```bash
./.venv/bin/python -m pip check
git diff --check
grep -R -n -E 'RuntimeWarning|ConvergenceWarning|Traceback|CellExecutionError' _freeze/chapters/chapterNN --include='*.json'
grep -n -E 'RuntimeWarning|ConvergenceWarning|Traceback|CellExecutionError' _book/chapters/chapterNN.html
```

- Full success means both `_book/index.html` and `_book/machine-learning-I.pdf` exist; chapter HTML alone does not verify the PDF path.

## Book Conventions

- Chapter membership and order come only from `_quarto.yml`; a `.qmd` file can exist without being part of the book.
- Keep `{{< chapter-actions >}}` near the top of downloadable chapters. `_extensions/chapter-actions/` emits HTML-only links to the exported notebook and `machine-learning-I.pdf`.
- Bibliographic entries belong in `references.bib`; cite them from QMD with Pandoc citation syntax such as `[@key]`.
- Preserve existing concurrent work. This repository is often dirty with large generated freeze/notebook diffs; never clean or regenerate unrelated chapters merely to reduce status noise.
