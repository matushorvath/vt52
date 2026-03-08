include <common.scad>
include <body_planes.scad>

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
    // TODO use separate YZ profile values for different X, using BOSL2 skin()
    profiles = [
        body_yz_half_plane(YZ_TOP_HALF[0], YZ_BOTTOM_HALF[0], BODY_Y, YZ_TOP_CORNER_R),
        body_yz_half_plane(YZ_TOP_HALF[1], YZ_BOTTOM_HALF[1], BODY_Y, YZ_TOP_CORNER_R),
        body_yz_half_plane(YZ_TOP_HALF[2], YZ_BOTTOM_HALF[2], BODY_Y, YZ_TOP_CORNER_R),
        body_yz_half_plane(YZ_TOP_HALF[3], YZ_BOTTOM_HALF[3], BODY_Y, YZ_TOP_CORNER_R),
        body_yz_half_plane(YZ_TOP_HALF[4], YZ_BOTTOM_HALF[4], BODY_Y, YZ_TOP_CORNER_R),
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

intersection() {
    body_xy();
    body_yz();
    // TODO body_zx();
};
