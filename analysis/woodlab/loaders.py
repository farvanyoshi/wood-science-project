"""Reading and validating the raw CSV files in data/raw."""

from __future__ import annotations

import csv
from collections import defaultdict
from pathlib import Path


class DataError(ValueError):
    """Raised when a raw data file is missing columns or contains invalid values."""


def read_table(path: Path, required: dict[str, type]) -> list[dict]:
    """Read a CSV into a list of dicts, converting the `required` columns to their types.

    Extra columns are kept as strings. Missing columns, empty cells and unparsable
    values raise DataError naming the file, the row and the column.
    """
    path = Path(path)
    if not path.exists():
        raise DataError(f"{path}: file not found")
    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        missing = set(required) - set(reader.fieldnames or [])
        if missing:
            raise DataError(f"{path.name}: missing column(s) {sorted(missing)}")
        rows = []
        for line, raw in enumerate(reader, start=2):
            row = dict(raw)
            for col, typ in required.items():
                value = (raw[col] or "").strip()
                if value == "":
                    raise DataError(f"{path.name}:{line}: empty value in column '{col}'")
                try:
                    row[col] = typ(value)
                except ValueError:
                    raise DataError(f"{path.name}:{line}: cannot read '{value}' in column '{col}' as {typ.__name__}") from None
            rows.append(row)
    if not rows:
        raise DataError(f"{path.name}: no data rows")
    return rows


def require_positive(rows: list[dict], columns: list[str], name: str) -> None:
    for i, row in enumerate(rows, start=2):
        for col in columns:
            if row[col] <= 0:
                raise DataError(f"{name}:{i}: '{col}' must be positive, got {row[col]}")


def require_unique(rows: list[dict], key: tuple[str, ...], name: str) -> None:
    seen = set()
    for row in rows:
        k = tuple(row[c] for c in key)
        if k in seen:
            raise DataError(f"{name}: duplicate row for {dict(zip(key, k))}")
        seen.add(k)


def require_one_pressure_per_block(rows: list[dict], name: str) -> None:
    pressures = defaultdict(set)
    for row in rows:
        pressures[row["block_id"]].add(row["pressure_mpa"])
    for block, ps in pressures.items():
        if len(ps) != 1:
            raise DataError(f"{name}: block {block} has several pressures {sorted(ps)}")


SEGMENT_COLUMNS = {
    "block_id": int, "segment_id": int, "pressure_mpa": float, "soak_h": float,
    "length_mm": float, "width_mm": float, "thickness_mm": float, "mass_g": float,
    "span_mm": float, "gauge_load_t": float,
}


def load_segments(raw: Path) -> list[dict]:
    rows = read_table(raw / "vc_segments.csv", SEGMENT_COLUMNS)
    require_positive(rows, ["length_mm", "width_mm", "thickness_mm", "mass_g", "span_mm", "gauge_load_t"], "vc_segments.csv")
    require_unique(rows, ("block_id", "segment_id"), "vc_segments.csv")
    require_one_pressure_per_block(rows, "vc_segments.csv")
    for i, row in enumerate(rows, start=2):
        if row["span_mm"] >= row["length_mm"]:
            raise DataError(f"vc_segments.csv:{i}: span {row['span_mm']} mm is not shorter than the segment ({row['length_mm']} mm)")
    return rows


def load_block_measurements(raw: Path, filename: str, value: str, index: str) -> list[dict]:
    rows = read_table(raw / filename, {"block_id": int, "pressure_mpa": float, index: int, value: float})
    require_positive(rows, [value], filename)
    require_unique(rows, ("block_id", index), filename)
    require_one_pressure_per_block(rows, filename)
    return rows


def load_impact(raw: Path) -> list[dict]:
    rows = read_table(raw / "impact.csv", {"dissolution_h": float, "specimen": int, "energy_ftlb": float})
    require_positive(rows, ["energy_ftlb"], "impact.csv")
    require_unique(rows, ("dissolution_h", "specimen"), "impact.csv")
    return rows


def load_exclusions(raw: Path, segments: list[dict]) -> dict[tuple[int, int], set[str]]:
    """Map (block_id, segment_id) -> set of quantity names excluded for that segment."""
    rows = read_table(raw / "exclusions.csv", {"block_id": int, "segment_id": int, "quantities": str})
    known = {(s["block_id"], s["segment_id"]) for s in segments}
    out: dict[tuple[int, int], set[str]] = defaultdict(set)
    for i, row in enumerate(rows, start=2):
        key = (row["block_id"], row["segment_id"])
        if key not in known:
            raise DataError(f"exclusions.csv:{i}: no segment with block {key[0]}, segment {key[1]}")
        out[key].update(q.strip() for q in row["quantities"].split(";") if q.strip())
    return dict(out)


def load_curve(path: Path) -> tuple[list[float], list[float]]:
    """Read a two-column curve export; returns (x, y) in file order."""
    path = Path(path)
    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.reader(f)
        header = next(reader)
        if len(header) != 2:
            raise DataError(f"{path.name}: expected 2 columns, found {len(header)}")
        xs, ys = [], []
        for line, row in enumerate(reader, start=2):
            try:
                x, y = map(float, row)
            except ValueError:
                raise DataError(f"{path.name}:{line}: invalid row {row}") from None
            xs.append(x)
            ys.append(y)
    if len(xs) < 2:
        raise DataError(f"{path.name}: needs at least two points")
    return xs, ys
