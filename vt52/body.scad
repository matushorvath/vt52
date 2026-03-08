include <common.scad>
include <body_details.scad>
include <body_planes.scad>
include <body_tables.scad>

include <BOSL2/std.scad>

module body_xy() {
    linear_sweep(
        body_xy_plane(),
        height = 2 * max(YZ_BOTTOM_HALF),
        orient = UP,
        center = true
    );
}

module body_yz_half() {
    profiles = [
        body_yz_half_plane(YZ_TOP_HALF[0], YZ_BOTTOM_HALF[0], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X000),
        body_yz_half_plane(YZ_TOP_HALF[1], YZ_BOTTOM_HALF[1], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X050),
        body_yz_half_plane(YZ_TOP_HALF[2], YZ_BOTTOM_HALF[2], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X100),
        body_yz_half_plane(YZ_TOP_HALF[3], YZ_BOTTOM_HALF[3], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X150),
        body_yz_half_plane(YZ_TOP_HALF[4], YZ_BOTTOM_HALF[4], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X200),
    ];

    skin(
        profiles,
        z = YZ_X,
        slices = 10,
        orient = RIGHT
    );
}

module body_yz() {
    union() {
        body_yz_half();
        zflip() body_yz_half();
    }
}

xrot(90) // orient the model for easy viewing in OpenSCAD
difference() {
    intersection() {
        body_xy();
        body_yz();
    };

    kbd_front_corners_mask();
};
