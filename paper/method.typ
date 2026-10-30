#import "/lib/style.typ": apa-figure, num, qty, numrange, qtyrange
#import "/lib/style.typ": ce


= Materials and Methods

== Materials
To achieve the aims laid out within the Engineering Goal section of the paper previously, the materials obtained and utilized within this project were separated into three broad categories, as shown below.

=== Lignin Removal
The blocks of wood which would be used throughout the entire project were cut from nominal 2" by 4" wood planks of Southern Yellow Pine (SYP), the true dimensions of which being $#qty(38, "mm") times #qty(89, "mm")$, obtained at a local lumber supply store. A total of 10 blocks were cut from these planks to the dimensions of $#qty(89, "mm") times #qty(89, "mm") times #qty(51, "mm")$. Due to the nature of the processing and sourcing of these blocks, some of the edges on some of the blocks had been slightly rounded. However, when compared to other blocks after experimentation, no significant difference was observed between those of rounded edge and those whose edges had remained completely intact during sourcing.

The lignin dissolution process itself required submerging blocks of wood within prepared solutions for extended periods of time. For this purpose, multiple #qty(1, "L") and #qty(2, "L") Pyrex beakers were used with standard ring stands, which were attached to a thermometer clamp with a stirring rod inserted to keep the block submerged (as wood has a tendency to float). Multiple beakers and stands were used to parallelize the process and heighten efficiency. The entire setup can be seen in @dissolution-setup.

#apa-figure(
  image("/assets/images/method/full-setup.jpeg"),
  caption: [A view of the lignin dissolution setup, with the beakers, hot plates, ring stands, and stirring rods.]
) <dissolution-setup>

In addition to the immersion setup, various standard equipment was used. These included the weigh boat and mass balance for accurately determining the amounts needed of the compounds used (seen in @balance), the hot plate and thermometer used for achieving and controlling near-boiling temperatures over sustained intervals (seen in @solution). As some of the chemicals (notably sodium hydroxide) are of corrosive nature, the lignin dissolution process was performed entirely under a fume hood with safety goggles and other personal protective equipment used.

#grid(
  columns: 2,
  [#apa-figure(
    image("/assets/images/method/balance.png"),
    caption: [The mass balance used for mass measurements.]
  ) <balance>],
  [#apa-figure(
    image("/assets/images/method/beaker+plate.jpeg"),
    caption: [A view of the solution, with the temperature controlled via a hot plate and a thermometer.]
  ) <solution>]
)

The dissolution process required producing an alkaline sodium sulfite solution to bathe the wood blocks in. As explained in the introduction, sodium hydroxide and sodium sulfite are used to make this solution. However, due to the high pH necessary for each solution and the considerable amount of lab grade sodium hydroxide that would be necessary, this paper opted to use drain cleaner, which is almost pure sodium hydroxide, as a cheaper substitute. The specific brand, shown in @hydroxide, was Instant Power 100% Crystal Lye Drain Opener. Lab grade sodium sulfite from Flinn Scientific was obtained from the Dallastown Area High School Chemistry lab, as seen in @sulfite. Each trial required #qty(50, "g") of sodium hydroxide and #qty(25.2, "g") of sodium sulfite, thus leading to a total usage of #qty(400, "g") of sodium hydroxide and #qty(201.6, "g") of sodium sulfite. To neutralize the wood blocks after alkaline treatment, citric acid was used in solution as a second bath, requiring #qty(80, "g") per trial and thus #qty(640, "g") in all. The specific citric acid used can be seen in @citric.

#grid(
  columns: (1fr, 1fr, 1fr),
  [#apa-figure(
    image("/assets/images/method/hydroxide.jpeg", height: 20%, fit: "cover"),
    caption: [The sodium hydroxide used.]
  ) <hydroxide>],
  [#apa-figure(
    image("/assets/images/method/sulfite.jpeg", height: 20%),
    caption: [The sodium sulfite used.]
  ) <sulfite>],
  [#apa-figure(
    image("/assets/images/method/citric.jpeg", height: 20%),
    caption: [The citric acid used.]
  ) <citric>]
)

=== Hot Pressing
Fundamentally, only two things are needed for effective hot pressing: a way to exert constant elevated pressure to the block of wood, and a steady source of heat to keep the block at high temperatures over the entire trial. The image shown in @press shows a diagram of the specific hydraulic press used, which was an Elementool 10-Ton Hydraulic Press with Pressure Gauge. A press with a maximum exerted weight of least 10 tons and a pressure gauge were necessary to perform the tests and verify the accuracy of the compression for such sustained periods of time.

#apa-figure(
  image("/assets/images/method/press-diagram.jpeg", height: 29%),
  caption: [A diagram of the hydraulic press used.]
) <press>

#pagebreak()

Under such compressive load, the wood blocks would have the tendency to spread out instead of compressing. Thus, various mild steel pieces were used to create a casing that would hold the wood in place, forming the wood containment apparatus that can be seen in the method section. The dimensions of the six steel blocks were as follows: a $#qty(152.4, "mm") times #qty(152.4, "mm") times #qty(50.8, "mm")$ block, a $#qty(88.9, "mm") times #qty(88.9, "mm") times #qty(6.35, "mm")$ block, and four $#qty(95.25, "mm") times #qty(38.1, "mm") times #qty(6.35, "mm")$ blocks. As these steel blocks were simply used for keeping the wood block in place, it was determined that the type of steel would have no effect and thus the most readily available steel for machining was used. A drill, welder, saw, and other basic machining equipment were used to machine steel into these pieces. This covers how to apply the constant pressure to the wood.

To keep the wood blocks heated for the entire period, four Coliao polyamide film heating pads with adhesive backing were used. These heating pads were rated for safe heating up to #qty(170, "celsius"), requiring #qty(30, "W") at #qty(24, "V"). An example diagram of one of the heating pads is shown in @pad. Two #qty(24, "V"), #qty(6, "A") DC power supplies were run on #qty(120, "V") AC wall input to power the heating pads, with each supply powering two of the pads. To minimize the loss of heat to the rather cold environment (which could not be afforded due to the high heat capacity of the steel blocks being used), ceramic fiber insulation was used to fully wrap up the apparatus like a box.

#apa-figure(
  image("/assets/images/method/pad-diagram.png", height: 23%),
  caption: [A diagram of one of the heating pads used.]
) <pad>

#pagebreak()

=== Flexural Strength Testing
As the original analysis done of the wood samples was in the form of flexural strength testing with the hydraulic press, each sample needed to be cut into section with a length much greater than their width. For this, a ruler was used to precisely measure the wood to be cut into 5 roughly equal-sized fragments. The same balance shown in @balance was reused to ensure similar masses between fragments. The load gauge, shown in @gauge, was used to calculate the maximum load each sample could withstand before reaching ultimate mechanical failure.

#apa-figure(
  image("/assets/images/method/gauge.jpg", height: 30%),
  caption: [The gauge on the hydraulic press used to measure applied load.]
) <gauge>

The time of wood fracture and load of the press was calculated via custom video-based analysis method developed using Python and OpenCV. The videos themselves were recorded with a standard smartphone camera such that the analog load indicator (in this case, the pressure gauge) was visible throughout the loading process. 

In each video, the first frame was used for calibration. A pivot center, a zero-load reference, and a known calibration load on the pressure gauge were all manually selected points that formed the basis of the calibration method. The angular displacement of the dial on the pressure gauge was then linearly interpolated to calculate the force exerted. Specifically, the furthest point from the pivot (in other words, the dial tip) was tracked as it moved across the gauge and its angular displacement was computed via trigonometry:

$ tan(theta) = (Delta y) / (Delta x) $
$ theta = arctan((y - y_0) / (x - x_0) ) $ <ang-disp>

After adjusting for angle wraparound potentially occurring due to the nature of the arctan function, the angle from @ang-disp is tracked to find its maximum value. That maximum angle was then used to determine the maximum force the block endured:

$ F = (theta - theta_0) / (theta_"cal" - theta_0) dot F_"cal" $ <force-calc>

To track the dial tip throughout the video, each frame was first converted to grayscale and filtered to isolate the indicator needle through OpenCV. Contours near the pivot point were examined, and the point of maximum radial distance from the pivot was then identified as the dial tip. @ang-disp and @force-calc were then used to linearly interpolate a maximum force value prior to specimen failure, enabling a simple and contactless measurement of flexural load without the need for dedicated sensors. The full code for the program is provided in @code-appendix.

=== Impact Testing
Impact testing was done at the York College of Pennsylvania using their Tinius-Olsen IT-406 impact tester for use in the lower energy Charpy impact test. Wood samples needed to be cut to certain dimensions for use in impact testing, requiring standard machining tools. However, no other extra equipment was required for these tests.

== Methods
This section will follow a similar format to that of the Materials section, while broadly following the theory outlined for these processes within the introduction.

=== Dissolution of Lignin
For each trial, #qty(25.2, "g") of solid anhydrous #ce("Na2SO3") was added to #qty(500, "mL") of distilled water in a #qty(1, "L") beaker. This beaker was then placed onto a hot plate and stirred with a magnetic stir bar until the solid had completely dissolved. This was followed by adding #qty(50, "g") of solid anhydrous #ce("NaOH") (obtained from the drain cleaner) to the mixture and mixed until complete dissolution. At this point the solution is incredibly basic, with concentrations of $ce("[NaOH]") = #qty(2.5, "molar")$ and $ce("[Na2SO3]") = #qty(0.4, "M")$. As sodium hydroxide is a strong base, the pH of this solution is 14.4 and was thus handled with extreme care. A glass thermometer was placed in the solution to monitor the temperature as the hot plate was powered to heat the solution to #qty(90, "celsius").

Once the solution reached the desired temperature, a block of pine was placed in it and secured using the stirring rod apparatus mentioned in the materials section. A ring stand was placed next to the hot plate and held a thermometer clamp. A stirring rod, with the held end wrapped in duct tape to prevent damage, was placed in that clamp and kept the wood block submerged in the solution. This was shown in @dissolution-setup.

Of the 10 blocks, 5 were marked for variable compressive load (constant lignin dissolution) and 5 were marked for variable lignin dissolution (constant compressive load). This paper will refer to the blocks of variable compression as VC blocks and those of variable dissolution as VL from here on. VC wood blocks were left to bathe at as close to #qty(90, "celsius") as possible for 6 hours, which had achieved the best results in prior research @song_2018_processing. The VL wood blocks used the same process but the time left submerged in solution was varied from 3 hours to 8 hours, skipping over 6 hours since that had already been covered in the VC wood blocks. After this, the leftover alkaline solution was neutralized within a temperature-controlled environment with #qty(80, "g") of citric acid and disposed of using a drain. 

Due to wood's absorbent qualities, some of the hydroxide ions were absorbed with the water into the wood, giving it an extremely basic pH (the blue color in the pH strip) that is demonstrated in @pH. Thus, the wood needed to be neutralized. While Song et al. (2018) doused the wood samples in boiling water 3 times to wash them, this paper opted for a more efficient method based in acid neutralization. A citric acid solution was created by adding #qty(50, "g") of citric acid (#ce("C6H8O7")) to #qty(500, "mL") of water. As citric acid has a pH far closer to neutral than sodium hydroxide, the concentration did not need to be exact. The wood block was soaked in citric acid solution overnight to make sure any leftover sodium hydroxide would be neutralized. These samples were then wrapped in a paper towel to absorb excess moisture and labeled to ensure accountability of wood samples.

#apa-figure(
  image("/assets/images/method/pH.jpeg", height: 30%),
  caption: [One of the pH strips after being used on the wood sample. It shows an extremely alkaline pH.]
) <pH>

=== Hot Pressing
Securing the wood block during compression necessitated the construction of a wood containment apparatus. The largest block was used as the base of the setup. The four smaller steel rectangles were aligned into a square, resulting in a rectangular prism with inner dimensions of $#qty(88.9, "mm") times #qty(88.9, "mm") times #qty(50.8, "mm")$. The remaining block was used as a "lid" during pressing to distribute the pressure evenly across the wood block and prevent crushing at one point.

During the pressing, it was realized that often the wood blocks would get stuck in such a closely fitting containment apparatus. Thus a hole was drilled through the base block with a hand drill to push the wood block out from beneath if it were to get stuck. The four polyamide heating pads were adhered to the four walls of the wood containment chamber. As mentioned before, two heating pads were connected to each power source, which were then connected to wall power. The entirety of the wood containment chamber is shown in @chamber.

#apa-figure(
  image("/assets/images/method/chamber.jpeg", height: 30%),
  caption: [An image of the entire wood containment apparatus.]
) <chamber>

For each trial, the block of pine was placed into the welded compartment, the lid was placed on top, and the blocks were aligned on the press so as to make sure the force is applied in the center, as shown in @full-press. The compression began by a rapid increase in pressure to #qty(12, "MPa") to squeeze excess water and ensure effective compression afterward. The pressure was then dropped to the actual pressure that would be used for that trial and left overnight to properly compress the block. /*For the VC blocks, t*/These compression pressures began at #qty(3, "MPa") and increased by #qty(1, "MPa") per new trial, to a maximum of #qty(7, "MPa"). /*All VL wood blocks were compressed at #qty(6, "MPa").*/ As mentioned before, blocks that became stuck in the chamber were removed by pushing out from the drilled hole with a metal rod. After the completion of each trial, the block's final thickness was measured and recorded.

#apa-figure(
  image("/assets/images/method/pressing.jpeg", height: 40%),
  caption: [The full pressing setup just before a trial.]
) <full-press>

=== Flexural Strength Analysis
The flexural strength analysis procedure required the usage of blocks whose lengths were considerably greater than their widths and heights to be done effectively. Thus, half of each wood block was cut into five roughly equal segments along the grain using a chop saw. To verify that this chopping had been done precisely enough, each block's dimensions were measured and recorded. The mass, using the balance from @balance, was also recorded and verified as an additional check.

After the cuts and verifications for each segment had been done, each block was marked along its length at two positions. Most blocks were marked at positions #qty(70, "mm") apart, but for blocks too short to utilize that distance, markings were done #qty(60, "mm") apart instead. This discrepancy was then accounted for during data analysis.

Two steel supports were placed across the press bed to hold up the wood segments during strength testing. Each segment was placed on the blocks so that the distance between the marked sections was not supported from below, allowing for flexing within that distance. As implied by the prior measurement, the unsupported section was either #qty(60, "mm") or #qty(70, "mm"), depending on the segment. A third steel block was used to narrow the force of the press ram onto the center of the wood fragment, as seen in @flex. This third block simply needed to be thin at the point of contact, and so a $#qty(75, "mm") times #qty(145, "mm") times #qty(20, "mm")$ steel block was used.

#apa-figure(
  image("/assets/images/method/flexural.jpeg", height: 30%),
  caption: [An image of the flexural strength testing setup.]
) <flex>

A smartphone video camera was set up to have a direct and head-on view of the press gauge. This specific view was necessary to reduce parallax error. A video of the press gauge during loading was taken (like the picture seen before in @gauge), as the force of the press was slowly increased until the wood achieved ultimate failure. During testing, this was immediately noticeable by a large drop in load and a loud snap that could be heard. This procedure was completed for all VC blocks and half of each VL block. This difference is due to tensile and impact testing from York College being available for VL blocks, while it was not available at the time at which the VC blocks were tested. The program specified in the materials and recorded in @code-appendix was used to analyze the videos frame by frame to determine the maximum load in the method described before.

In later tests, a separate video camera (in the case of this paper, using a laptop webcam) was used to record the movement of the press ram as it pressed into the block. This camera also had to be placed so as to minimize parallax error. Since calculating flexural stress and strain values requiring continuous data collection, the script from before could not be used for this purpose. Instead, the Tracker software, provided by Open Source Physics, was used for continuous video analysis and determination of the raw quantities of load strength and midpoint deflection that are necessary for stress and strain calculations, respectively @brown_2024_tracker.

=== Impact Testing
The other half of each VL block was used for impact testing. Four 10mm x 10mm x 55mm segments were cut from the remaining portions of those blocks. The Tinius-Olsen IT-406 impact tester was used in its lower energy Charpy configuration for conducting testing in accordance with the machine's standard operating instructions. The wood was placed and cut so that the grain ran perpendicular to the applied force. After testing, each wood sample was salvaged for post-failure analysis.