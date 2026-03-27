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
        // TODO YZ_TOP_HALF can be read from YZ_CURVE_X*, no need to pass it
        // TODO YZ_BOTTOM_HALF would be read from YZ_CURVE_X* in the ideal world, but YZ_CURVE_X000 does not always have value for Y=0
        // TODO add all values for Y=0 to YZ_CURVE_X*, read them from Sheet 30 Data List #2 where not available, use that instead of YZ_BOTTOM_HALF
        // TODO YZ_TOP_CORNER_R and SCR_TOP_Y are constants
        body_yz_half_plane(outside, YZ_TOP_HALF[0], YZ_BOTTOM_HALF[0], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X000),
        body_yz_half_plane(outside, YZ_TOP_HALF[1], YZ_BOTTOM_HALF[1], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X050),
        body_yz_half_plane(outside, YZ_TOP_HALF[2], YZ_BOTTOM_HALF[2], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X100),
        body_yz_half_plane(outside, YZ_TOP_HALF[3], YZ_BOTTOM_HALF[3], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X150),
        body_yz_half_plane(outside, YZ_TOP_HALF[4], YZ_BOTTOM_HALF[4], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X200),
        body_yz_half_plane(outside, YZ_TOP_HALF[5], YZ_BOTTOM_HALF[5], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X250),
        body_yz_half_plane(outside, YZ_TOP_HALF[6], YZ_BOTTOM_HALF[6], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X300),
        body_yz_half_plane(outside, YZ_TOP_HALF[7], YZ_BOTTOM_HALF[7], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X350),
        body_yz_half_plane(outside, YZ_TOP_HALF[8], YZ_BOTTOM_HALF[8], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X400),
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
