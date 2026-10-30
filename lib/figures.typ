// Figure builders. Every plotted value comes from /data via lib/data.typ.
// Each function returns an `apa-figure`, so callers can attach a label: `#mean-plot(..) <density>`.

#import "style.typ": apa-figure, lq, unit
#import "data.typ": *

#let pressure-label = [Pressure (MPa)]

/// Mean ± SE of a summary quantity against applied pressure.
/// `excluded: true` uses the statistics with the outliers in data/raw/exclusions.csv removed.
#let mean-plot(quantity, ylabel, caption: none, note: none, excluded: false) = {
  let suffix = if excluded { "_excl" } else { "" }
  apa-figure(
    lq.diagram(
      xlabel: pressure-label,
      ylabel: ylabel,
      lq.plot(
        pressures,
        series(quantity, field: "mean" + suffix),
        yerr: series(quantity, field: "se" + suffix),
      ),
    ),
    caption: caption,
    note: note,
  )
}

/// One line per segment position (1–5) of a per-segment column against pressure.
#let segment-plot(column, ylabel, caption: none, note: none) = apa-figure(
  lq.diagram(
    xlabel: pressure-label,
    ylabel: ylabel,
    legend: (position: (100% + 0.5em, 0%)),
    ..range(5).map(i => lq.plot(
      pressures,
      pressures.map(p => segment-values(column, p).at(i)),
      label: [Segment #(i + 1)],
    )),
  ),
  caption: caption,
  note: note,
)

/// Charpy impact energy per dissolution time as box plots.
#let impact-plot(caption: none, note: none) = apa-figure(
  lq.diagram(
    xlabel: [Dissolution Time (h)],
    ylabel: [Impact Energy (J)],
    xaxis: (ticks: dissolution-times.map(h => (h, str(h)))),
    ..dissolution-times.map(h => lq.boxplot(
      x: h,
      impact.filter(r => r.dissolution_h == h).map(r => r.energy_j),
      mean: blue,
    )),
  ),
  caption: caption,
  note: note,
)

/// A raw curve export (data/raw/curves/<name>.csv) as a line.
#let curve-plot(name, xlabel, ylabel, caption: none, note: none) = {
  let (xs, ys) = curve(name)
  apa-figure(
    lq.diagram(
      xaxis: (tick-distance: auto, subticks: auto),
      xlabel: xlabel,
      ylabel: ylabel,
      lq.plot(xs, ys),
    ),
    caption: caption,
    note: note,
  )
}

/// A curve's linear region together with its least-squares line (from data/processed/fits.csv).
/// `digits` sets the number of decimals shown for (slope, intercept) in the legend.
#let fit-plot(name, fit-name, xlabel, ylabel, digits: (3, 3), xlim: auto, ylim: auto, caption: none, note: none) = {
  let (xs, ys) = curve(name)
  let f = fit(fit-name)
  let line-x = if xlim == auto { (f.x-min, f.x-max) } else {
    (if xlim.at(0) == auto { f.x-min } else { xlim.at(0) },
     if xlim.at(1) == auto { f.x-max } else { xlim.at(1) })
  }
  let (m, b) = (fixed(f.slope, digits.at(0)), fixed(f.intercept, digits.at(1)))
  apa-figure(
    lq.diagram(
      legend: (position: bottom + right),
      xlim: xlim,
      ylim: ylim,
      xaxis: (tick-distance: auto, subticks: auto),
      xlabel: xlabel,
      ylabel: ylabel,
      lq.plot(xs, ys, label: [Data]),
      lq.plot(line-x, x => f.slope * x + f.intercept, mark-size: 0pt, stroke: black,
        label: $y = #m x + #b$),
    ),
    caption: caption,
    note: note,
  )
}

/// Mean whole-block mass (5 repeat weighings) against pressure.
#let block-mass-plot(caption: none, note: none) = mean-plot("block_mass_g", [Mass (g)], caption: caption, note: note)
