// Summaries for the tri-fold presentation board. Build with `typst compile poster.typ`.
#import "@preview/versatile-apa:7.2.0": versatile-apa as apa-style

#set document(
  title: [Structural Enhancement of Wood through Chemical Treatment and Thermo-Mechanical Densification],
  keywords: ("Wood", "Chemical Treatment", "Densification"),
  description: "",
)

#show: apa-style.with(
  font-size: 14pt
)

#set page(numbering: none)

#set figure(placement: none)

#include "poster/intro.typ"

#pagebreak()
#include "poster/method.typ"

#pagebreak()
#include "poster/figures.typ"

#pagebreak()
#include "poster/discussion.typ"

#pagebreak()
#include "poster/conclusion.typ"