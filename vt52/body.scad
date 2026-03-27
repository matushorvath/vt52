include <common.scad>
include <body_details.scad>
include <body_dimensions.scad>
include <body_planes.scad>
include <BOSL2/std.scad>

// TODO texture = "rough" for both body shapes?

module body_xy(outside) {
    linear_sweep(
        body_xy_plane(outside),
        center = true,
        height = 2 * max(XZ_CURVE_Y000), // make sure to cover widest part of the YZ profile
        orient = UP
    );
}

module body_yz_half(outside) {
    profiles = [
        body_yz_half_plane(outside, XZ_CURVE_Y000[0], YZ_CURVE_X000),
        body_yz_half_plane(outside, XZ_CURVE_Y000[1], YZ_CURVE_X050),
        body_yz_half_plane(outside, XZ_CURVE_Y000[2], YZ_CURVE_X100),
        body_yz_half_plane(outside, XZ_CURVE_Y000[3], YZ_CURVE_X150),
        body_yz_half_plane(outside, XZ_CURVE_Y000[4], YZ_CURVE_X200),
        body_yz_half_plane(outside, XZ_CURVE_Y000[5], YZ_CURVE_X250),
        body_yz_half_plane(outside, XZ_CURVE_Y000[6], YZ_CURVE_X300),
        body_yz_half_plane(outside, XZ_CURVE_Y000[7], YZ_CURVE_X350),
        body_yz_half_plane(outside, XZ_CURVE_Y000[8], YZ_CURVE_X400),
        // TODO decide depth of the model
    ];

    xmove(outside ? 0 : DELTA) // move inside plane to clear the back side of the terminal
        skin(
            profiles,
            z = YZ_X,
            slices = 20,
            orient = RIGHT
        );
}

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

// xrot(90) // orient the model for easy viewing in OpenSCAD
//     body(true);
