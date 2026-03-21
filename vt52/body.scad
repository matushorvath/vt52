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
        height = 2 * max(YZ_BOTTOM_HALF),
        orient = UP
    );
}

module body_yz_half(outside) {
    profiles = [
        body_yz_half_plane(outside, YZ_TOP_HALF[0], YZ_BOTTOM_HALF[0], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X000),
        body_yz_half_plane(outside, YZ_TOP_HALF[1], YZ_BOTTOM_HALF[1], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X050),
        body_yz_half_plane(outside, YZ_TOP_HALF[2], YZ_BOTTOM_HALF[2], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X100),
        body_yz_half_plane(outside, YZ_TOP_HALF[3], YZ_BOTTOM_HALF[3], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X150),
        body_yz_half_plane(outside, YZ_TOP_HALF[4], YZ_BOTTOM_HALF[4], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X200),
        body_yz_half_plane(outside, YZ_TOP_HALF[5], YZ_BOTTOM_HALF[5], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X250),
        body_yz_half_plane(outside, YZ_TOP_HALF[6], YZ_BOTTOM_HALF[6], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X300),
        body_yz_half_plane(outside, YZ_TOP_HALF[7], YZ_BOTTOM_HALF[7], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X350),
        body_yz_half_plane(outside, YZ_TOP_HALF[8], YZ_BOTTOM_HALF[8], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X400),
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
    union() {
        body_yz_half(outside);
        zflip() body_yz_half(outside);
    }
}

module body(outside) {
    difference() { // TODO diff()
        intersection() { // TODO intersect()
            body_xy(outside);
            body_yz(outside);
        };

        kbd_fwd_corners_mask(outside);
    };
}

// xrot(90) // orient the model for easy viewing in OpenSCAD
//     body(true);
