// Named results quoted in the prose, so the text always matches the data.

#import "style.typ": qty, num
#import "data.typ": *

/// Modulus of rupture of untreated (control) pine reported in the paper's Discussion.
/// It comes from a separate control test and is not reproduced from data/raw (see data/README.md).
#let natural-mor = 68

#let best-pressure = 7
#let best-sw = stat("sw_knm_per_kg", best-pressure)          // kN·m/kg
#let best-mor = stat("mor_mpa", best-pressure)               // MPa
#let mor-gain = best-mor / natural-mor                       // × untreated pine
#let stiffness = fit("flexural_stiffness").slope             // kN/mm
#let flexural-modulus = fit("flexural_modulus").slope        // MPa
#let aluminium-sw = 115                                      // 6061-T6, kN·m/kg (literature)

/// `#q(best-sw, 0, "kN m/kg")` → a quantity rounded to `digits` decimals.
#let q(value, digits, unit) = qty(fixed(value, digits), unit)
