include <common.scad>
include <body_dimensions.scad>

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/shapes2d.scad>
include <BOSL2/trigonometry.scad>

module body_xy_plane() {
    shape = [
        [0, 0],                                             // keyboard front bottom
        [kbd_front_x, KBD_FRONT_Y],                         // keyboard front top
        [kbd_back_x, kbd_back_y],                           // keyboard back top
        [SCR_TOP_X, BODY_Y],                                // body front top
        [BODY_BACK_X, BODY_Y],                              // body back top
        [BODY_BACK_X, 0]                                    // body back bottom
    ];

    radii = [
        0, 0, KBD_BACK_R, 0, 0, 0
    ];

    polygon(round_corners(shape, radius=radii));
}

module body_yz_half_plane(top_half_x, bottom_half_x, height_y, corner_r) {
    // Approximate shape without the rounded side
    shape = [
        [0, 0],                                             // center bottom
        [0, height_y],                                      // center top
        [top_half_x + corner_r, height_y],                  // side top
        [bottom_half_x, 0]                                  // side bottom
    ];

    radii = [
        0, 0, corner_r, 0
    ];

    polygon(round_corners(shape, radius=radii));

    // TODO make the side rounded, not straight
}

body_yz_half_plane(X182_TOP_HALF, X182_BOTTOM_HALF, BODY_Y, X182_CORNER_R);
