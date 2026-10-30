// Full research paper. Build with `typst compile paper.typ` (or `make paper`).
#import "@preview/versatile-apa:7.2.0": abstract-page, appendix, appendix-outline, title-page, versatile-apa as apa-style

#set document(
  title: [Structural Enhancement of Wood through Chemical Treatment and Thermo-Mechanical Densification],
  keywords: ("Wood", "Chemical Treatment", "Densification"),
  description: "",
)

#show: apa-style.with(
  font-size: 12pt,
  running-head: ""
)

#set figure(placement: none)

#title-page() 

#abstract-page(
  include "paper/abstract.typ"
)

#outline()
#pagebreak()
#outline(target: figure.where(kind: table), title: [Tables])
#pagebreak()
#outline(target: figure.where(kind: image), title: [Figures])
#pagebreak()
#appendix-outline(title: [Appendices])
#pagebreak()

#include "paper/intro.typ"

#pagebreak()
#include "paper/method.typ"

#pagebreak()
#include "paper/results.typ"

#pagebreak()
#include "paper/discussion.typ"

#pagebreak()
#include "paper/conclusion.typ"

#pagebreak()
#bibliography(
  "/references/refs.bib",
  full: true,
  title: [References],
)

#show: appendix

#include "paper/appendix.typ"
