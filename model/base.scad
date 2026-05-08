// use
include <common.scad>
include <base_dimensions.scad>
include <body_dimensions.scad>
include <data_lists.scad>
include <BOSL2/std.scad>

use <base_planes.scad>

// Bottom curve between 0 and EE, which defines slice height for the corner [base_fc_x, base_fc_y]
function base_bottom_height_y_0_ee(a) =
    // At a = 90 the height is base_fc_x, at a = 0 the height is base_ee_y
    // The mixed X and Y coordinates are because the slices rotate from X to Y
    let(
        ratio_a = (90 - a) / 90,
        dh = (base_ee_y - base_fc_x)
    )
    base_fc_x + ratio_a * dh;

// Side angle between 0 and EE
function base_side_angle_0_ee(a) =
    // At a = 90 the side angle is calculated from XZ_CURVE_Y000
    // At a = 0 the side angle is BASE_EE_A
    let(
        a90_side_angle = adj_opp_to_ang(base_fc_x - BASE_R, lookup(base_fc_x, XZ_CURVE_Y000) - lookup(BASE_R, XZ_CURVE_Y000)),
        ratio_a = (90 - a) / 90,
        d_side_angle = (BASE_EE_A - a90_side_angle)
    )
    a90_side_angle + ratio_a * d_side_angle;

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
// TODO this looks weird linear, use a similar curve to base_bottom_curve_y
function base_side_angle_ee_ff_ee_ff(x) =
    BASE_EE_A + (x - BASE_EE_X) * (BASE_FF_A - BASE_EE_A) / (BASE_FF_X - BASE_EE_X);

function base_side_angle_ee_ff(x) =
    (x < BASE_EE_X)
    ? BASE_EE_A // TODO rounded front corner
    : (x >= BASE_EE_X && x < BASE_FF_X)
        ? base_side_angle_ee_ff_ee_ff(x)
        : BASE_FF_A;

module base_object_half(mask) {
    profiles = [
        // Slices for the rounded front edge; the ZY slice maps to XY coordinates here
        // TODO refactor this into functions
        for (a = [90:-BASE_0_FF_STEP_A:0])
            xrot(
                a = a,
                p = path3d(base_ee_ff_half_plane(mask, lookup(base_fc_x, XZ_CURVE_Y000),
                    base_bottom_height_y_0_ee(a), base_side_angle_0_ee(a)), base_fc_x),
                cp = [0, base_fc_y, base_fc_x]
            ),

        // TODO not contiguous in E-E
        // TODO weird angle in 0, should be at most horizontal, but is actually over horizontal
        // because the planes get extended with every angle increase - the shape is wrong, rethink
        // TODO the correct shape won't be extending slice height but slice vertical position (then we have to calc slice height)
        // TODO the side angle is also wrong 0 to E-E, it shouldn't just linearly change,
        // it should be defined in X and Y and combined, so it looks contiguous

        // Slices along the E-E to F-F section
        for (x = [BASE_EE_X:BASE_EE_FF_STEP_X:BASE_FF_X])
            path3d(base_ee_ff_half_plane(mask, lookup(x, XZ_CURVE_Y000), base_bottom_curve_y(x), base_side_angle_ee_ff(x)), x),

        // One slice at the end of the F-F to back section
        path3d(base_ee_ff_half_plane(mask, lookup(BODY_BACK_X, XZ_CURVE_Y000), base_bottom_curve_y(BODY_BACK_X), base_side_angle_ee_ff(BODY_BACK_X)), BODY_BACK_X)
    ];

    // The keyboard area is extended into -X by extend_fwd_bot_x, so we need to space the keyboard area
    // planes further from each other in X; keyboard area is x < kbd_back_x
    // TODO implement; the X coordinate to stretch is part of 3d profiles above
    // stretched_yz_x = [
    //     for (x = [0:YZ_INTERVAL_X:BODY_BACK_X])
    //         if (x < kbd_back_x)
    //             kbd_back_x - (kbd_back_x - x) * (kbd_back_x + extend_fwd_bot_x) / kbd_back_x
    //         else
    //             x
    // ];
    // stretched_yz_x = [
    //     for (x = [BASE_EE_X:BASE_EE_FF_STEP_X:BASE_FF_X]) x,
    //     BODY_BACK_X
    // ];

    move(mask ? [DELTA, DELTA, 0] : [0, 0, 0]) // clear the top and back sides
        skin(
            profiles,
            slices = 0, // we calculate enough of our own slices, avoid interpolation by BOSL
            method = "fast_distance", // needed because the rounded corners are incommensurate
            orient = RIGHT
        );
}

// base_object_half(false);

module base_object(mask) {
    zflip_copy()
        base_object_half(mask);
}

// base_object(true);
// %base_object(false);

module base() {
    ymove(-BASE_Y)
        difference() {
            // Base object with a cavity
            base_object(false);
            base_object(true);
        };
}

// Orient the model for easy viewing in OpenSCAD
xrot(90)
    base();
