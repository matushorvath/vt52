// use
include <common.scad>
include <base_dimensions.scad>
include <body_dimensions.scad>
include <data_lists.scad>
include <BOSL2/std.scad>

use <base_planes.scad>

// TODO some of these functions may be unused, clean up

// Bottom curve between 0 and EE, added to the rotated slice in Y direction
function base_bottom_curve_y_0_ee(x) =
    // At x = 0 we don't add anything; at x = BASE_EE_X we add (base_ee_y - BASE_R)
    x * (base_ee_y - BASE_R) / BASE_EE_X;

// Center of rotation for the 0 to EE slices
function base_rot_center_x_0_ee(x) =
    // At x = 0 the center is at BASE_R; at x = BASE_EE_X the center is at BASE_EE_X
    BASE_R + x * (BASE_EE_X - BASE_R) / BASE_EE_X;

// Angle of rotation for the 0 to EE slices
function base_rot_angle_0_ee(x) =
    // At x = 0 the angle is 90; at x = BASE_EE_X the angle is 0
    90 - x * 90 / BASE_EE_X;

// Side angle between 0 and EE
// TODO wrong, it should be defined in X and Y and combined, so it looks contiguous
base_a90_side_angle = adj_opp_to_ang(base_fc_x - BASE_R, lookup(base_fc_x, XZ_CURVE_Y000) - lookup(BASE_R, XZ_CURVE_Y000));
function base_side_angle_0_ee(x) =
    // At x = 0 the side angle is base_a90_side_angle calculated from XZ_CURVE_Y000
    // At x = BASE_EE_X the side angle is BASE_EE_A
    base_a90_side_angle + x * (BASE_EE_A - base_a90_side_angle) / BASE_EE_X;

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

module base_0_ee_half(mask) {
    profiles = [
        // Slices for the rounded front edge; the ZY slice maps to XY coordinates here
        // TODO refactor this into functions
        for (x = [0:BASE_0_EE_STEP_X:BASE_EE_X - BASE_0_EE_STEP_X])
            let(
                // Avoid calculating these multiple times
                bottom_curve_y = base_bottom_curve_y_0_ee(x),
                rot_center_x = base_rot_center_x_0_ee(x),
                rot_angle = base_rot_angle_0_ee(x),
                side_angle = base_side_angle_0_ee(x),

                // Extend each slice up by bottom_curve_y so its top reaches BODY_Y, at the correct angle
                extend_height = x == 0 ? 0 : ang_adj_to_hyp(rot_angle, bottom_curve_y)
                // TODO this extension causes the slices to intersect
                // We should instead angle the slices so they point and extend to their [rot_center_x, BASE_Y]
                // without using base_rot_angle_0_ee at all
                // Another point: Since the slices are moved down, we should also reduce their width, since
                // the EE slice down there is narrower (30 degrees inside from the width on top)
                // That might actually solve most of the problem;
                // but it's also almost equivalent to extending the slices, which is better and anyway needed
                // -> try angling and extending the slices towards [rot_center_x, BASE_Y]
                //
                // New plan: Don't extend at all. Make the front edge a completely separate object, glue them together
            )
            ymove(
                y = -bottom_curve_y,
                p = xrot(
                    a = rot_angle,
                    p = path3d(
                            ymove(
                                y = extend_height,
                                p = base_ee_ff_half_plane(
                                    mask,
                                    lookup(rot_center_x, XZ_CURVE_Y000),
                                    BASE_R + extend_height,
                                    side_angle // TODO this is not contiguous, since the angles are themselves angled with slices
                                )
                            ),
                        rot_center_x),
                    cp = [0, base_fc_y, rot_center_x]
                )
            ),

        // Add the E-E slice to make sure this is contiguous with base_ee_ff_half
        path3d(base_ee_ff_half_plane(mask, lookup(BASE_EE_X, XZ_CURVE_Y000), base_bottom_curve_y(BASE_EE_X), base_side_angle_ee_ff(BASE_EE_X)), BASE_EE_X),
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

    // for (path = profiles) {
    //     stroke(path);
    // }
}

// base_0_ee_half(false);

module base_ee_ff_half(mask) {
    profiles = [
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

    // for (path = profiles) {
    //     stroke(path);
    // }
}

// base_ee_ff_half(false);

module base_object(mask) {
    zflip_copy() {
        base_0_ee_half(mask);
        base_ee_ff_half(mask);
    }
}

// TODO base_object with true or false causes render errors, base_ee_ff_half works; maybe it's because of complex and wrong ZY profile
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
