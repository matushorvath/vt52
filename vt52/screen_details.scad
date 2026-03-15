include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

// TODO add small features - cutout, bug, ribs
// TODO add front bezel border ? if it exists

// TODO louvres on top of screen bezel, Sheet 4, View G-G

// TODO pattern on bottom of screen bezel, Sheet 8
//  - indentation right after keyboard starts Section CI-CI
//    - round corners 2.5R 2 places View I-I
//    - indentation depth .5 tangential, length 20 X, Section CG-CG
//  - ribs, 6 pieces, tangential to the complex shape
//    - defined in Section CF-CF (back) Section CH-CH (forward, including the step for indentation)
//    - parallel with X
//      - try either BOSL2 placement, or maybe extrude a 2d shape without the side angles which makes it parallel with X

module screen_bottom_bezel_flat() {
    // Bottom bezel features referenced from
}
