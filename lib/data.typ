// Access to the generated data in /data/processed (see data/README.md).
// Paths starting with "/" resolve from the project root, so this works from any file.

#let pressures = (3, 4, 5, 6, 7)
#let dissolution-times = (5, 6, 8)

#let _load(name) = csv("/data/processed/" + name + ".csv", row-type: dictionary)

#let segments = _load("segments").map(r => {
  for (k, v) in r { if k != "excluded" { r.insert(k, float(v)) } }
  r
})
#let impact = _load("impact").map(r => r.pairs().map(((k, v)) => (k, float(v))).to-dict())
#let fits = _load("fits").map(r => (r.name, r)).to-dict()
#let _summary = _load("summary")

/// One summary statistic, e.g. `stat("mor_mpa", 7)` or `stat("mor_mpa", 4, field: "se_excl")`.
/// Fields: n, mean, sd, se, n_excl, mean_excl, sd_excl, se_excl.
#let stat(quantity, level, field: "mean") = {
  let rows = _summary.filter(r => r.quantity == quantity and float(r.level) == float(level))
  assert(rows.len() == 1, message: "no summary row for " + quantity + " at " + str(level))
  float(rows.first().at(field))
}

/// The values of `field` for `quantity` across `levels` (an array, in order).
#let series(quantity, field: "mean", levels: pressures) = levels.map(l => stat(quantity, l, field: field))

/// Per-segment values of a column for one pressure, ordered by segment.
#let segment-values(column, pressure) = (
  segments
    .filter(r => r.pressure_mpa == pressure)
    .sorted(key: r => r.segment_id)
    .map(r => r.at(column))
)

/// A fit's coefficient, e.g. `fit("flexural_modulus").slope`.
#let fit(name) = {
  let f = fits.at(name)
  (slope: float(f.slope), intercept: float(f.intercept), r2: float(f.r2),
   x-min: float(f.x_min), x-max: float(f.x_max))
}

/// A raw curve export as two arrays (x, y).
#let curve(name) = {
  let rows = csv("/data/raw/curves/" + name + ".csv").slice(1)
  (rows.map(r => float(r.at(0))), rows.map(r => float(r.at(1))))
}

/// Format a number with a fixed number of decimals (keeps trailing zeros).
#let fixed(x, digits) = {
  if digits <= 0 { return str(int(calc.round(x))) }
  let s = str(calc.round(x, digits: digits))
  if not s.contains(".") { s += "." }
  let (whole, frac) = s.split(".")
  whole + "." + frac + "0" * (digits - frac.len())
}

/// Format a number to `n` significant figures.
#let sig(x, n: 3) = {
  if x == 0 { return "0" }
  let mag = int(calc.floor(calc.log(calc.abs(x), base: 10)))
  fixed(x, calc.max(n - 1 - mag, 0))
}

/// Whole-block measurements from data/raw: a dictionary pressure -> array of readings in order.
#let block-readings(file, column) = {
  let rows = csv("/data/raw/" + file + ".csv", row-type: dictionary)
  pressures.map(p => (str(p), rows.filter(r => float(r.pressure_mpa) == p).map(r => float(r.at(column))))).to-dict()
}
