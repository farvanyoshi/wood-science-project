"""Build data/processed from data/raw."""

from __future__ import annotations

import csv
from pathlib import Path

from woodlab import derive, loaders
from woodlab.stats import Summary, group_by, linear_fit

# Per-segment quantities summarised by pressure (column in segments.csv -> name in summary.csv).
SEGMENT_QUANTITIES = {
    "thickness_mm": "segment_thickness_mm",
    "width_mm": "segment_width_mm",
    "mass_g": "segment_mass_g",
    "density_g_cm3": "density_g_cm3",
    "load_kn": "load_kn",
    "mor_mpa": "mor_mpa",
    "sw_knm_per_kg": "sw_knm_per_kg",
}

# Linear-region fits: name -> (curve file in raw/curves, x label, y label).
FITS = {
    "flexural_stiffness": ("vl-5h-seg2_load-deflection_linear.csv", "deflection_mm", "load_kn"),
    "flexural_modulus": ("vl-5h-seg2_stress-strain_linear.csv", "strain", "stress_mpa"),
}

SUMMARY_FIELDS = ["quantity", "level", "n", "mean", "sd", "se", "n_excl", "mean_excl", "sd_excl", "se_excl"]


def fmt(value):
    """Stable text form for CSV output: 6 significant digits for floats, integers kept as-is."""
    if isinstance(value, float):
        if value.is_integer() and abs(value) < 1e6:
            return str(int(value))
        return f"{value:.6g}"
    return value


def write_csv(path: Path, fields: list[str], rows: list[dict]) -> None:
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields, lineterminator="\n")
        w.writeheader()
        for row in rows:
            w.writerow({k: fmt(row[k]) for k in fields})


def summary_row(quantity: str, level, values: list[float], kept: list[float] | None = None) -> dict:
    s = Summary.of(values)
    e = Summary.of(kept if kept is not None else values)
    return {"quantity": quantity, "level": level, "n": s.n, "mean": s.mean, "sd": s.sd, "se": s.se,
            "n_excl": e.n, "mean_excl": e.mean, "sd_excl": e.sd, "se_excl": e.se}


def build(raw: Path, out: Path) -> dict[str, Path]:
    raw, out = Path(raw), Path(out)
    out.mkdir(parents=True, exist_ok=True)

    segments = [derive.derive_segment(r) for r in loaders.load_segments(raw)]
    exclusions = loaders.load_exclusions(raw, segments)
    for s in segments:
        s["excluded"] = ";".join(sorted(exclusions.get((s["block_id"], s["segment_id"]), ())))

    unknown = {q for qs in exclusions.values() for q in qs} - set(SEGMENT_QUANTITIES)
    if unknown:
        raise loaders.DataError(f"exclusions.csv: unknown quantities {sorted(unknown)}")

    summary = []
    for column, name in SEGMENT_QUANTITIES.items():
        for pressure, rows in group_by(segments, "pressure_mpa").items():
            values = [r[column] for r in rows]
            kept = [r[column] for r in rows if column not in r["excluded"].split(";")]
            summary.append(summary_row(name, pressure, values, kept))

    for filename, value, index, name in [
        ("vc_blocks_mass.csv", "mass_g", "weighing", "block_mass_g"),
        ("vc_blocks_thickness.csv", "thickness_mm", "position", "block_thickness_mm"),
    ]:
        rows = loaders.load_block_measurements(raw, filename, value, index)
        for pressure, group in group_by(rows, "pressure_mpa").items():
            summary.append(summary_row(name, pressure, [r[value] for r in group]))

    impact = [derive.derive_impact(r) for r in loaders.load_impact(raw)]
    for hours, group in group_by(impact, "dissolution_h").items():
        summary.append(summary_row("impact_j", hours, [r["energy_j"] for r in group]))

    fits = []
    for name, (filename, xlabel, ylabel) in FITS.items():
        xs, ys = loaders.load_curve(raw / "curves" / filename)
        f = linear_fit(xs, ys)
        fits.append({"name": name, "source": filename, "x": xlabel, "y": ylabel, "n": f.n,
                     "slope": f.slope, "intercept": f.intercept, "r2": f.r2,
                     "x_min": f.x_min, "x_max": f.x_max})

    seg_fields = list(loaders.SEGMENT_COLUMNS) + ["volume_cm3", "density_g_cm3", "load_kn", "mor_mpa",
                                                  "sw_knm_per_kg", "excluded"]
    paths = {
        "segments": out / "segments.csv",
        "summary": out / "summary.csv",
        "impact": out / "impact.csv",
        "fits": out / "fits.csv",
    }
    write_csv(paths["segments"], seg_fields, segments)
    write_csv(paths["summary"], SUMMARY_FIELDS, summary)
    write_csv(paths["impact"], ["dissolution_h", "specimen", "energy_ftlb", "energy_j"], impact)
    write_csv(paths["fits"], list(fits[0]), fits)
    return paths
