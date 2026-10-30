"""Command-line entry point: `python -m woodlab build`."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from woodlab.loaders import DataError
from woodlab.pipeline import build

REPO = Path(__file__).resolve().parents[2]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="woodlab", description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    b = sub.add_parser("build", help="regenerate data/processed from data/raw")
    b.add_argument("--raw", type=Path, default=REPO / "data" / "raw")
    b.add_argument("--out", type=Path, default=REPO / "data" / "processed")
    args = parser.parse_args(argv)

    if args.command == "build":
        try:
            paths = build(args.raw, args.out)
        except DataError as e:
            print(f"error: {e}", file=sys.stderr)
            return 1
        for p in paths.values():
            print(f"wrote {p.relative_to(REPO) if p.is_relative_to(REPO) else p}")
    return 0
