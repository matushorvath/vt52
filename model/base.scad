// use
include <common.scad>
include <base_dimensions.scad>
include <body_dimensions.scad>
include <data_lists.scad>
include <BOSL2/std.scad>

use <base_planes.scad>

// Bottom curve between EE and FF
function base_bottom_curve_y_ee_ff(x) =
    let(
        // X distance between this point and FF
        dx = BASE_FF_X - x,
        // Y distance between this point and EE
        dy = base_curve_ee_ff_r - sqrt(base_curve_ee_ff_r^2 - dx^2)
    )
    base_ff_y - dy;

function base_bottom_curve_y(x) =
    (x < BASE_EE_X)
    ? base_ee_y // TODO rounded front corner
    : (x >= BASE_EE_X && x < BASE_FF_X)
        ? base_bottom_curve_y_ee_ff(x)
        : base_ff_y;

// Side angle between EE and FF
function base_side_angle_ee_ff(x) =
    BASE_EE_A + (x - BASE_EE_X) * (BASE_FF_A - BASE_EE_A) / (BASE_FF_X - BASE_EE_X);

function base_side_angle(x) =
    (x < BASE_EE_X)
    ? BASE_EE_A // TODO rounded front corner
    : (x >= BASE_EE_X && x < BASE_FF_X)
        ? base_side_angle_ee_ff(x)
        : BASE_FF_A;

// TODO add mask parameter
module base_object_half() {
    profiles = [
        // Slices along the E-E to F-F section
        for (x = [BASE_EE_X:BASE_EE_FF_STEP_X:BASE_FF_X])
            base_ee_ff_half_plane(lookup(x, XZ_CURVE_Y000), base_bottom_curve_y(x), base_side_angle(x)),

        // One slice at the end of the F-F to back section
        base_ee_ff_half_plane(lookup(BODY_BACK_X, XZ_CURVE_Y000), base_bottom_curve_y(BODY_BACK_X), base_side_angle(BODY_BACK_X))
    ];

    // The keyboard area is extended into -X by extend_fwd_bot_x, so we need to space the keyboard area
    // planes further from each other in X; keyboard area is x < kbd_back_x
    // TODO implement
    // stretched_yz_x = [
    //     for (x = [0:YZ_INTERVAL_X:BODY_BACK_X])
    //         if (x < kbd_back_x)
    //             kbd_back_x - (kbd_back_x - x) * (kbd_back_x + extend_fwd_bot_x) / kbd_back_x
    //         else
    //             x
    // ];
    stretched_yz_x = [
        for (x = [BASE_EE_X:BASE_EE_FF_STEP_X:BASE_FF_X]) x,
        BODY_BACK_X
    ];

    // TODO xmove(outside ? 0 : DELTA) // move inside plane to clear the back side of the terminal
        skin(
            profiles,
            z = stretched_yz_x,
            slices = 0, // we calculate enough of our own slices, avoid interpolation by BOSL
            method = "fast_distance", // needed because the rounded corners are incommensurate
            orient = RIGHT
        );
}

//base_object_half();

// TODO add mask parameter
module base_object() {
    zflip_copy()
        base_object_half();
}

base_object();

// module base() {
//     difference() {
//         intersection() {
//             body_xy(outside);
//             body_yz(outside);
//         };

//         kbd_fwd_corners_mask(outside);
//     };
// }

// body(false);
// %body(true);
