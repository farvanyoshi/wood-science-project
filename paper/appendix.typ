#import "/lib/tables.typ": *

// keep each table together with its caption
#show figure: set block(breakable: false)

= Tables

== Raw Data

#segment-table("thickness_mm", "segment_thickness_mm",
  caption: [Thickness of wood sample segments as a function of applied pressure.],
  note: [Thickness values are reported in millimeters. M = mean; SE = standard error of the mean.],
) <raw-thickness>

#segment-table("mass_g", "segment_mass_g", digits: 2,
  caption: [Mass of wood sample segments as a function of applied pressure.],
  note: [Mass values are reported in grams. M = mean; SE = standard error of the mean.],
) <raw-mass>

#segment-table("width_mm", "segment_width_mm",
  caption: [Width of wood sample segments as a function of applied pressure.],
  note: [Width values are reported in millimeters. M = mean; SE = standard error of the mean.],
) <raw-width>

#block-table("vc_blocks_thickness", "thickness_mm", "block_thickness_mm", first: [Position],
  caption: [Thickness of the pressed wood blocks, measured at eight positions around each block, as a function of applied pressure.],
  note: [Thickness values are reported in millimeters. Positions are the four corners and four edge midpoints of the block. M = mean; SE = standard error of the mean.],
) <raw-block-thickness>

#block-table("vc_blocks_mass", "mass_g", "block_mass_g", first: [Weighing], digits: 2,
  caption: [Mass of the pressed wood blocks, weighed five times each, as a function of applied pressure.],
  note: [Mass values are reported in grams. M = mean; SE = standard error of the mean.],
) <raw-block-mass>

#segment-table("load_kn", "load_kn", digits: 2,
  caption: [Maximum load of wood sample segments as a function of applied pressure.],
  note: [Load values are reported in kilonewtons, converted from the press gauge reading in metric tons ($F = 9.81 m$). M = mean; SE = standard error of the mean.],
) <raw-load>

#impact-table(
  caption: [Impact energy of wood specimens as a function of dissolution time.],
  note: [Impact energy values are reported in joules, converted from the tester's foot-pound readings. M = mean; SE = standard error of the mean.],
) <raw-impact>

== Calculated Data

#segment-table("density_g_cm3", "density_g_cm3", digits: 3,
  caption: [Density of wood sample segments as a function of applied pressure.],
  note: [Density values are reported in grams per cubic centimeter. M = mean; SE = standard error of the mean.],
) <raw-density>

#segment-table("mor_mpa", "mor_mpa", excluded: true,
  caption: [Modulus of rupture of wood sample segments as a function of applied pressure.],
  note: [Modulus of rupture values are reported in megapascals. Unsupported spans were 60 mm for the 3, 6, and 7 MPa blocks and 70 mm for the 4 and 5 MPa blocks. The value marked \* is the outlier excluded from the "no outlier" rows. M = mean; SE = standard error of the mean.],
) <raw-mor>

#segment-table("sw_knm_per_kg", "sw_knm_per_kg", digits: 0, excluded: true,
  caption: [Strength-to-weight ratio of wood sample segments as a function of applied pressure.],
  note: [Strength-to-weight values are reported in kilonewton-meters per kilogram. The value marked \* is the outlier excluded from the "no outlier" rows. M = mean; SE = standard error of the mean.],
) <raw-sw>

= Computer Code <code-appendix>
#raw(read("/tools/gauge_reader.py"), lang: "py")
