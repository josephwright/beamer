#!/usr/bin/env python3
"""Check forward-search page selection using the installed SyncTeX client.

From the repository root:
    python3 testfiles/check-synctex.py
    python3 testfiles/check-synctex.py --engine xelatex --engine lualatex

The temporary build uses this checkout's class and packages. No installation
or third-party Python packages are needed. Every subprocess has a timeout.
"""

import argparse
import os
from pathlib import Path
import re
import subprocess
import tempfile


def run(command, **kwargs):
    result = subprocess.run(command, capture_output=True, text=True, timeout=20, **kwargs)
    if result.returncode:
        raise RuntimeError(f"{command[0]} failed:\n{result.stdout[-4000:]}\n{result.stderr}")
    return result.stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", action="append", help="default: pdflatex")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    source = root / "testfiles/synctex-forward.tex"
    cases = [(line, int(match[1]))
             for line, text in enumerate(source.read_text().splitlines(), 1)
             if (match := re.search(r"SYNCTEX_PAGE=(\d+)", text))]
    env = dict(os.environ, TEXINPUTS=str(root / "base") + "//:")
    for engine in args.engine or ["pdflatex"]:
        with tempfile.TemporaryDirectory(prefix="beamer-synctex-") as directory:
            run([engine, "-synctex=1", "-interaction=nonstopmode", "-halt-on-error", str(source)],
                cwd=directory, env=env)
            pdf = Path(directory) / (source.stem + ".pdf")
            for line, expected in cases:
                output = run(["synctex", "view", "-i", f"{line}:0:{source}", "-o", str(pdf)])
                match = re.search(r"^Page:(\d+)$", output, re.MULTILINE)
                actual = int(match[1]) if match else None
                if actual != expected:
                    raise AssertionError(
                        f"{engine}: source line {line}: expected page {expected}, got {actual}")
            print(f"{engine}: {len(cases)} forward-search checks passed")


if __name__ == "__main__":
    main()
