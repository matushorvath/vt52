include <common.scad>
include <body_planes.scad>

include <BOSL2/std.scad>

module body_xy() {
    linear_sweep(
        body_xy_plane(),
        height = 2 * X182_BOTTOM_HALF,
        orient = UP,
        center = true
    );
}

module body_yz_half() {
    // TODO use separate YZ profile values for different X, using BOSL2 skin()
    linear_sweep(
        body_yz_half_plane(X182_TOP_HALF, X182_BOTTOM_HALF, BODY_Y, X182_CORNER_R),
        height = 2 * X182_BOTTOM_HALF,
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
