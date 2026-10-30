#import "/lib/style.typ": apa-figure, diagrams, unit
#import "/lib/figures.typ": *

#show: diagrams

#apa-figure(
  image("/assets/images/method/full-setup.jpeg", height: 40%),
  caption: [A view of the lignin dissolution setup.]
) <dissolution-setup>

#grid(
  columns: (1fr, 1em, 1fr),
  apa-figure(
    image("/assets/images/method/chamber.jpeg", height: 35%),
    caption: [The wood containment apparatus.]
  ),
  [],
  apa-figure(
    image("/assets/images/method/pressing.jpeg", height: 35%),
    caption: [The pressing setup just before a trial.]
  ),
)

#apa-figure(
  image("/assets/images/method/flexural.jpeg", height: 35%),
  caption: [The flexural strength testing setup.]
) <flex>
 \
#grid(
  columns: (1fr, 0em, 1fr),
  apa-figure(
    image("/assets/images/method/pH.jpeg", height: 33%),
    caption: [A highly alkaline pH strip after usage on a wood sample.]
  ),
  [],
  apa-figure(
    image("/assets/images/method/pad-diagram.png", height: 38%),
    caption: [A diagram of one of the heating pads.]
  )
)

#impact-plot(
  caption: [Energy dissipated on impact during a Charpy impact test, presented as boxplots.],
  note: [Blue lines represent mean values, and orange lines represent median values.],
) <impact>
 \
#mean-plot("density_g_cm3", [Density #unit("g/cm^3")],
  caption: [Mean density of variable compression segments as a function of applied pressure.],
) <density>
\ \ \ \
#segment-plot("mor_mpa", [MOR (MPa)],
  caption: [Moduli of rupture of variable compression segments per segment position as a function of applied pressure.],
) <mor>
 \
#mean-plot("mor_mpa", [MOR (MPa)], excluded: true,
  caption: [Mean moduli of rupture of variable compression segments as a function of applied pressure, with the outlier found in the 4 MPa segment testing removed.],
) <mean-mor-no-outlier>
 \ \ \
#let sw-label = align(center)[Strength/Weight Ratio (#unit("kN m/kg"))]
#segment-plot("sw_knm_per_kg", sw-label,
  caption: [Strength to weight ratio of variable compression segments per segment position as function of applied pressure.],
) <stw>
 \
#mean-plot("sw_knm_per_kg", sw-label, excluded: true,
  caption: [Mean strength to weight ratio of variable compression segments as a function of applied pressure, with the outlier found in the 4 MPa segment testing removed.],
) <mean-stw-no-outlier>
 \ \ \
#apa-figure(
  image("/assets/images/results/post-test.jpeg", height: 40%),
  caption: [An image of one of the wood samples after testing for flexural strength.]
) <post-test>
