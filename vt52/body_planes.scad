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

module body_yz_plane() {
    // TODO
    // shape = [
    //     [0, 0],                                             // keyboard front bottom
    //     [kbd_front_x, KBD_FRONT_Y],                         // keyboard front top
    //     [kbd_back_x, kbd_back_y],                           // keyboard back top
    //     [SCR_TOP_X, BODY_Y],                                // body front top
    //     [BODY_BACK_X, BODY_Y],                              // body back top
    //     [BODY_BACK_X, 0]                                    // body back bottom
    // ];

    // radii = [
    //     0, 0, KBD_BACK_R, 0, 0, 0
    // ];

    // polygon(round_corners(shape, radius=radii));

    // TODO the profile in YZ plane is slightly different for different X, see Figure 3 - Figure 16
}

body_yz_plane();
