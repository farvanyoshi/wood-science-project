# Data

`raw/` holds the measurements as they were recorded. Files in it are edited by hand only to fix a transcription error.
`processed/` is **generated** by `python -m woodlab build` (see [`analysis/`](../analysis)) and committed, so the
Typst documents compile without Python. Never edit `processed/` by hand.

## Experimental design

| Series | Blocks | Varied | Held constant |
|---|---|---|---|
| **VC** (variable compression) | 5 blocks (IDs 1–5) | hot-press pressure 3, 4, 5, 6, 7 MPa | 6 h lignin dissolution |
| **VL** (variable lignin dissolution) | 5 h, 6 h, 8 h blocks | dissolution time | pressing |

After pressing, each VC block was weighed and measured. Half of each block was then cut along the grain into five
flexural segments. Each segment was broken in three-point bending on the hydraulic press, and the peak gauge reading
was read from video (see [`tools/gauge_reader.py`](../tools/gauge_reader.py)).

## Raw files

| File | One row per | Columns | Source |
|---|---|---|---|
| `raw/vc_segments.csv` | VC flexural segment | `block_id`, `segment_id`, `pressure_mpa`, `soak_h`, `length_mm`, `width_mm`, `thickness_mm`, `mass_g`, `span_mm`, `gauge_load_t` (peak load in **metric tonnes**, as read from the press gauge) | Data spreadsheet (`full_vc_spec.csv`), rough draft Tables 3–6 |
| `raw/vc_blocks_mass.csv` | weighing of a whole pressed VC block (5 repeats) | `block_id`, `pressure_mpa`, `weighing`, `mass_g` | Rough draft Table 2 |
| `raw/vc_blocks_thickness.csv` | thickness reading on a whole pressed VC block (8 positions: corners and edges) | `block_id`, `pressure_mpa`, `position`, `thickness_mm` | Rough draft Table 1 |
| `raw/impact.csv` | Charpy specimen | `dissolution_h`, `specimen`, `energy_ftlb` (machine reads ft·lb) | Logbook p. 29 |
| `raw/vl_segments.csv` | VL flexural segment | `dissolution_h`, `segment_id`, `length_mm`, `width_mm`, `thickness_mm`, `mass_g` | Logbook p. 30 (no peak loads were recorded) |
| `raw/exclusions.csv` | excluded value | `block_id`, `segment_id`, `quantities` (`;`-separated), `reason` | Paper |
| `raw/curves/*.csv` | video-tracking sample | see below | Tracker (Open Source Physics) exports |

### Curves

| File | Columns | Notes |
|---|---|---|
| `vl-5h-seg2_load-deflection.csv` | `deflection_mm`, `load_kn` | 5 h VL segment 2, full test |
| `vl-5h-seg2_load-deflection_linear.csv` | same | hand-selected linear (elastic) region, used for the stiffness fit |
| `vl-5h-seg2_stress-strain.csv` | `strain`, `stress_mpa` | same test, exported as stress/strain |
| `vl-5h-seg2_stress-strain_linear.csv` | same | rows 299–334 of the file above, used for the flexural-modulus fit |
| `natural_load-deflection.csv`, `natural_stress-strain.csv` | as above | untreated (control) pine |

Rows in the curve files are in tracking order, **not** sorted by x.

## Derived quantities (computed in `analysis/woodlab/derive.py`)

| Quantity | Formula | Unit |
|---|---|---|
| volume | V = l·w·t / 1000 | cm³ |
| density | ρ = m / V | g/cm³ |
| peak load | F = gauge_load_t × 9.81 | kN |
| modulus of rupture | σ_r = 3 F L / (2 w t²) (F in N, L = `span_mm`) | MPa |
| strength-to-weight ratio | S/W = σ_r / ρ | kN·m/kg (numerically MPa per g/cm³) |
| impact energy | E = energy_ftlb × 1.35582 | J |

Summary statistics are the mean, the sample standard deviation `s`, and the standard error `SE = s/√n`.

## Known discrepancies and the decisions taken

1. **Test span for the 6 and 7 MPa blocks.** Three records disagree:

   | Source | 3 MPa | 4 MPa | 5 MPa | 6 MPa | 7 MPa |
   |---|---|---|---|---|---|
   | Spreadsheet (`full_vc_spec.csv`) | 60 | 70 | 70 | **60** | **60** |
   | Rough draft, Table 6 | 60 | 70 | 70 | 60 | 70 |
   | Values used in the original paper's MOR calculation | 60 | 70 | 70 | 70 | 70 |

   This repository uses the **spreadsheet** spans. Compared with the original paper, the 6 and 7 MPa moduli of
   rupture and strength-to-weight ratios are lower by a factor of 6/7. The trends and conclusions are unchanged. To
   use a different span, edit `span_mm` in `raw/vc_segments.csv` and rebuild.
2. **Summary rows in the original tables.** The original appendix tables had hand-typed M/SE rows. Two width means
   were wrong (3 MPa: 23.5 → 28.4 mm; 7 MPa: 30.4 → 25.8 mm). The SEs were not s/√n, and the mean loads were
   rounded in tonnes before converting to kN. All of these values are now computed from the raw rows.
3. **The two VL 5 h curve exports** do not convert into each other by a single constant factor (the stress/load
   ratio drifts from 15.1 to 15.7 MPa/kN). They are separate Tracker exports, and neither can be regenerated from the
   other, so both are kept as raw data.
4. **The natural-wood control curves** peak at only 2.1 kN / 18.4 MPa. The paper quotes a control modulus of rupture
   of 68 MPa from a different test. That value is cited from the paper and is not reproduced from these files.
5. **8 h impact specimens** (logbook) were not in the original paper. They are now included.
