// use
include <common.scad>
include <base_dimensions.scad>
include <body_tables.scad>
include <BOSL2/std.scad>

use <base_planes.scad>

// TODO add mask parameter
module base_object_half() {
    profiles = [
        // TODO perhaps sample more than every X=50, use more slices
        // TODO base_ee_ff_half_plane should receive a parameter 0.0 - 1.0, position between E-E and F-F
        base_ee_ff_half_plane(lookup(BASE_EE_X, XZ_CURVE_Y000), base_ee_y, BASE_EE_A),
        base_ee_ff_half_plane(lookup((BASE_EE_X + BASE_FF_X) / 2, XZ_CURVE_Y000), (base_ee_y + base_ff_y) / 2 , (BASE_EE_A + BASE_FF_A) / 2), // tmp mid plane
        base_ee_ff_half_plane(lookup(BASE_FF_X, XZ_CURVE_Y000), base_ff_y, BASE_FF_A)
    ];

    // The keyboard area is extended into -X by extend_fwd_bot_x, so we need to space the keyboard area
    // planes further from each other in X; keyboard area is x < kbd_back_x
    // TODO implement
    // stretched_yz_x = [
    //     for (x = YZ_X)
    //         if (x < kbd_back_x)
    //             kbd_back_x - (kbd_back_x - x) * (kbd_back_x + extend_fwd_bot_x) / kbd_back_x
    //         else
    //             x
    // ];
    stretched_yz_x = [BASE_EE_X, (BASE_EE_X + BASE_FF_X) / 2, BASE_FF_X]; // tmp X coordinates

    // TODO xmove(outside ? 0 : DELTA) // move inside plane to clear the back side of the terminal
        skin(
            profiles,
            z = stretched_yz_x,
            slices = 20, // TODO we should calculate enough of our own slices, avoid interpolation by BOSL
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
