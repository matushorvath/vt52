// use
include <common.scad>
include <body_dimensions.scad>
include <BOSL2/std.scad>

// Page 61, Sheet 2 of 2

// My copy of the document doesn't have Sheet 1 of 2, also it seems I either don't completely understand
// this drawing, or it has some errors. For example, the X, Y and Z axes seem to be mixed up in many places.
// This model is my best attempt at interpretating an incomplete drawing.

// The comments and variable names below use the same coordinate system as the shell, which isn't consistent
// with Page 61. Sitting at the terminal, front to back is X, bottom to top is Y, right to left is Z.

// Base height from top of the feet to bottom of the lip
BASE_Y = 60; // Page 61; height with half-lip 65 - half-lip 5

// Side radius of the base
BASE_R = 18.5;

// Parameters in Section E-E
base_ee_y = BASE_R; // height of the base, same as side radius
BASE_EE_A = 30; // side angle of the base

// Parameters in Section F-F
base_ff_y = BASE_Y; // height of the base, full height
BASE_FF_A = 15; // side angle of the base

// Lip around the top of the base, where it connects to shell
// TODO lip has more complex geometry
BASE_LIP_Y = 10;

// TODO
// apply top view curve for Z dimension of the base
// make EE and FF angle contiguous

// One of the
// TODO mask parameter for the mask
// TODO parametrize along the E-E F-F curve
function base_ee_ff_half_plane(width_z, height_y, angle) =
    // Unlike some other _plane functions, this uses model coordinates (horizontal Z and vertical Y)
    let(
        // Bottom coordinate is raised to align the top edge
        bottom_y = BASE_Y - height_y,

        // Bottom left corner if there was no rounding
        bottom_z = width_z - ang_adj_to_opp(angle, height_y),

        shape = [
            [0, bottom_y],
            [0, BASE_Y],
            [width_z, BASE_Y],
            [bottom_z, bottom_y]
        ],

        radii = [
            0, 0, 0, BASE_R
        ]
    )
    round_corners(shape, radius = radii);

polygon(base_ee_ff_half_plane(260, base_ee_y, BASE_EE_A)); // TODO use real curve instead of 260

ymove(100)
    polygon(base_ee_ff_half_plane(260, (base_ee_y + base_ff_y) / 2 , (BASE_EE_A + BASE_FF_A) / 2)); // TODO use real curve instead of 260

ymove(200)
    polygon(base_ee_ff_half_plane(260, base_ff_y, BASE_FF_A)); // TODO use real curve instead of 260
