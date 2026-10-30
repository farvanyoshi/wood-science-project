// Appendix tables, generated from the data. Values use a fixed number of decimals;
// standard errors are shown to 3 significant figures.

#import "style.typ": apa-figure
#import "data.typ": *

#let _pressure-header(levels, title: [Applied pressure (MPa)], first: [Segment]) = table.header(
  table.cell(rowspan: 2)[#first],
  table.cell(colspan: levels.len())[#title],
  ..levels.map(l => [#l]),
)

#let _table(levels, header, body) = table(
  columns: (12em,) + (1fr,) * levels.len(),
  header,
  table.hline(stroke: 0.5pt),
  ..body,
  table.hline(),
)

#let _stat-rows(quantity, digits, levels: pressures, excluded: false) = {
  let rows = (
    [M], ..series(quantity, levels: levels).map(x => fixed(x, digits)),
    [SE], ..series(quantity, field: "se", levels: levels).map(x => sig(x)),
  )
  if excluded {
    rows += (
      [M (no outlier)], ..series(quantity, field: "mean_excl", levels: levels).map(x => fixed(x, digits)),
      [SE (no outlier)], ..series(quantity, field: "se_excl", levels: levels).map(x => sig(x)),
    )
  }
  rows
}

/// Segment × pressure table of a per-segment column plus its summary rows.
/// Values excluded as outliers are marked with an asterisk.
#let segment-table(column, quantity, digits: 1, caption: none, note: none, excluded: false) = {
  let marked = segments.filter(r => column in r.excluded.split(";"))
  let cell(r) = fixed(r.at(column), digits) + (if r in marked { "*" } else { "" })
  let rows = range(1, 6).map(i => {
    let seg = segments.filter(r => r.segment_id == i).sorted(key: r => r.pressure_mpa)
    ([#i], ..seg.map(cell))
  }).flatten()
  apa-figure(
    _table(pressures, _pressure-header(pressures), rows + _stat-rows(quantity, digits, excluded: excluded)),
    caption: caption,
    note: note,
  )
}

/// Table of repeated whole-block readings (rows = repeat index) with summary rows.
#let block-table(file, column, quantity, first: [Reading], digits: 1, caption: none, note: none) = {
  let readings = block-readings(file, column)
  let n = readings.at("3").len()
  let rows = range(n).map(i => ([#(i + 1)], ..pressures.map(p => fixed(readings.at(str(p)).at(i), digits)))).flatten()
  apa-figure(
    _table(pressures, _pressure-header(pressures, first: first), rows + _stat-rows(quantity, digits)),
    caption: caption,
    note: note,
  )
}

/// Charpy impact energies (J) by dissolution time.
#let impact-table(caption: none, note: none) = {
  let by-h = dissolution-times.map(h => impact.filter(r => r.dissolution_h == h).sorted(key: r => r.specimen))
  let rows = range(by-h.first().len()).map(i => ([#(i + 1)], ..by-h.map(g => fixed(g.at(i).energy_j, 2)))).flatten()
  apa-figure(
    _table(
      dissolution-times,
      _pressure-header(dissolution-times, title: [Lignin dissolution time (h)], first: [Specimen]),
      rows + _stat-rows("impact_j", 2, levels: dissolution-times),
    ),
    caption: caption,
    note: note,
  )
}
