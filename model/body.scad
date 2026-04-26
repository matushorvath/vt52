// use
include <common.scad>
include <body_dimensions.scad>
include <body_tables.scad>
include <BOSL2/std.scad>

use <body_details.scad>
use <body_planes.scad>

// TODO texture = "rough" for both body shapes?

module body_xy(outside) {
    linear_sweep(
        body_xy_plane(outside),
        center = true,
        height = 2 * max([for (xz = XZ_CURVE_Y000) xz[1]]), // make sure to cover widest part of the YZ profile
        orient = UP
    );
}

// body_xy(true);

module body_yz_half(outside) {
    profiles = [
        body_yz_half_plane(outside, lookup(0, XZ_CURVE_Y000), YZ_CURVE_X000),
        body_yz_half_plane(outside, lookup(50, XZ_CURVE_Y000), YZ_CURVE_X050),
        body_yz_half_plane(outside, lookup(100, XZ_CURVE_Y000), YZ_CURVE_X100),
        body_yz_half_plane(outside, lookup(150, XZ_CURVE_Y000), YZ_CURVE_X150),
        body_yz_half_plane(outside, lookup(200, XZ_CURVE_Y000), YZ_CURVE_X200),
        body_yz_half_plane(outside, lookup(250, XZ_CURVE_Y000), YZ_CURVE_X250),
        // body_yz_half_plane(outside, lookup(300, XZ_CURVE_Y000), YZ_CURVE_X300),
        // body_yz_half_plane(outside, lookup(350, XZ_CURVE_Y000), YZ_CURVE_X350),
        // body_yz_half_plane(outside, lookup(400, XZ_CURVE_Y000), YZ_CURVE_X400),
    ];

    // The keyboard area is extended into -X by extend_fwd_bot_x, so we need to space the keyboard area
    // planes further from each other in X; keyboard area is x < kbd_back_x
    stretched_yz_x = [
        for (x = YZ_X)
            if (x < kbd_back_x)
                kbd_back_x - (kbd_back_x - x) * (kbd_back_x + extend_fwd_bot_x) / kbd_back_x
            else
                x
    ];

    xmove(outside ? 0 : DELTA) // move inside plane to clear the back side of the terminal
        skin(
            profiles,
            z = stretched_yz_x,
            slices = 20,
            orient = RIGHT
        );
}

// body_yz_half(true);

module body_yz(outside) {
    zflip_copy()
        body_yz_half(outside);
}

module body(outside) {
    difference() {
        intersection() {
            body_xy(outside);
            body_yz(outside);
        };

        kbd_fwd_corners_mask(outside);
    };
}

// body(false);
// %body(true);
