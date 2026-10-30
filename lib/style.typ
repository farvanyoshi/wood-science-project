// Package versions and plot styling shared by the paper and the poster.
// Every other file imports packages through here, so versions are pinned in one place.

#import "@preview/versatile-apa:7.2.0": apa-figure
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/unify:0.7.1": num, qty, unit, numrange, qtyrange

// Default look for all diagrams: y axis from zero, one x tick per MPa level.
#let diagrams(body) = {
  show: lq.set-diagram(
    ylim: (0, auto),
    xaxis: (mirror: false, tick-distance: 1, subticks: none),
    yaxis: (mirror: false),
    width: 90%,
  )
  show lq.selector(lq.diagram): set align(center)
  body
}
