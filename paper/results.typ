#import "/lib/style.typ": apa-figure, diagrams, unit
#import "/lib/figures.typ": *

#show: diagrams

= Results

The raw data is provided in the tables listed in Appendix A. All error bars show the standard error of the mean.

#mean-plot("segment_thickness_mm", [Thickness (mm)],
  caption: [Mean thickness of variable compression segments as a function of applied pressure.],
) <thickness>

#block-mass-plot(
  caption: [Mass of the pressed variable compression blocks as a function of applied pressure.],
  note: [Each value is the mean of five repeat weighings of the whole block; the standard errors are smaller than the markers.],
) <mass>

$quad$

#mean-plot("segment_width_mm", [Width (mm)],
  caption: [Mean width of variable compression segments as a function of applied pressure.],
) <width>

#mean-plot("load_kn", [Maximum Load (kN)],
  caption: [Mean maximum load of variable compression segments as a function of applied pressure.],
) <load-strength>

#curve-plot("vl-5h-seg2_load-deflection", [Deflection (mm)], [Load (kN)],
  caption: [The load endured by the 2nd 5 hour dissolution VL wood segment as a function of the distance the midpoint of the segment being tested had moved (the deflection).],
) <load-def>

#fit-plot("vl-5h-seg2_load-deflection_linear", "flexural_stiffness", [Deflection (mm)], [Load (kN)],
  digits: (3, 3), xlim: (0.38, 0.88),
  caption: [A zoomed-in view of the linear section of @load-def, with a line of best fit.],
) <s_load-def>

#impact-plot(
  caption: [Energy dissipated on impact during a Charpy impact test, presented as boxplots.],
  note: [The blue lines represent mean values. The orange values represent median values. These are otherwise standard box plots, showing the minimum, the quartiles, and the maximum.],
) <impact>

= Data Analysis

Density is calculated as follows:
$ rho = m/V = m/(l w t) $
where $rho$ is density, $m$ is mass, $V$ is volume, and $l, w, "and" t$ refer to the length, width, and thickness, respectively. The mean density of each wood block is shown in @density.

#mean-plot("density_g_cm3", [Density #unit("g/cm^3")],
  caption: [Mean density of variable compression segments as a function of applied pressure.],
) <density>

$quad$

Calculating the strength-to-weight ratio also requires determining the modulus of rupture for each block, which was directly determined from the maximum flexural load each fragment could bear:
$ sigma_r = (3 F l) / (2 w t^2) $
where $F$ is the maximum withstood flexural load, $l$ is the unsupported span, and $w "and" t$ retain their meanings from before. @mor shows the moduli of rupture for each segment.

#segment-plot("mor_mpa", [MOR (MPa)],
  caption: [Moduli of rupture of variable compression segments per segment position as a function of applied pressure.],
) <mor>
$quad$
#mean-plot("mor_mpa", [MOR (MPa)],
  caption: [Mean moduli of rupture of variable compression segments as a function of applied pressure.],
) <mean-mor>

$quad$

It was found that in the 4 MPa trials, one of the segments had a vastly different value for the modulus of rupture. This value was removed in @mean-mor-no-outlier, thus showing a clearer linear trend than in @mean-mor.

#mean-plot("mor_mpa", [MOR (MPa)], excluded: true,
  caption: [Mean moduli of rupture of variable compression segments as a function of applied pressure, with the outlier found in the 4 MPa segment testing removed.],
) <mean-mor-no-outlier>

These results were used to calculate strength-to-weight ratios. The exact calculation is:
$ "S/W" = sigma_r / rho $
where $sigma_r$ and $rho$ were defined as the modulus of rupture and the density, respectively.

#let sw-label = align(center)[Strength/Weight Ratio (#unit("kN m/kg"))]

#segment-plot("sw_knm_per_kg", sw-label,
  caption: [Strength to weight ratio of variable compression segments per segment position as a function of applied pressure.],
) <stw>

#mean-plot("sw_knm_per_kg", sw-label,
  caption: [Mean strength to weight ratio of variable compression segments as a function of applied pressure.],
) <mean-stw>

#mean-plot("sw_knm_per_kg", sw-label, excluded: true,
  caption: [Mean strength to weight ratio of variable compression segments as a function of applied pressure, with the outlier found in the 4 MPa segment testing removed.],
) <mean-stw-no-outlier>

#curve-plot("vl-5h-seg2_stress-strain", [Strain], [Stress (MPa)],
  caption: [The stress of the 2nd 5 hour VL wood segment with respect to the strain (normalized deflection).],
) <stress-strain>

#fit-plot("vl-5h-seg2_stress-strain_linear", "flexural_modulus", [Strain], [Stress (MPa)],
  digits: (0, 2), xlim: (auto, 0.017), ylim: (70, 120),
  caption: [A zoomed-in view of the linear section of @stress-strain, with a line of best fit.],
) <short>

#apa-figure(
  image("/assets/images/results/post-test.jpeg", height: 26%),
  caption: [An image of one of the wood samples after testing for flexural strength.],
) <post-test>
