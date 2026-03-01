include <common.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/shapes2d.scad>
include <BOSL2/trigonometry.scad>

// VT50_FMPS, Sheet 1

BODY_Y = 282;
KBD_FRONT_Y = 13.5;
KBD_FRONT_A = 30;
KBD_TOP_A = 13;
KBD_BACK_R = 14;
SCR_FRONT_A = 12;
SCR_TOP_X = 182;

// Customizations
BODY_BACK_X = 300;

// Calculate missing coordinates
kbd_front_x = adj_ang_to_opp(KBD_FRONT_Y, KBD_FRONT_A);

/*
kbd_back_x and kbd_back_y are only defined by KBD_FRONT_A and KBD_TOP_A

tan(KBD_TOP_A) = (y - KBD_FRONT_Y) / (x - kbd_front_x)
x * tan(KBD_TOP_A) - kbd_front_x * tan(KBD_TOP_A) + KBD_FRONT_Y = y

cotan(SCR_FRONT_A) = (y - BODY_Y) / (x - SCR_TOP_X)
x * cotan(SCR_FRONT_A) - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y = y

x * tan(KBD_TOP_A) - kbd_front_x * tan(KBD_TOP_A) + KBD_FRONT_Y =
  x * cotan(SCR_FRONT_A) - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y

x * tan(KBD_TOP_A) - x * cotan(SCR_FRONT_A) =
  kbd_front_x * tan(KBD_TOP_A) - KBD_FRONT_Y - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y

x = (kbd_front_x * tan(KBD_TOP_A) - KBD_FRONT_Y - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y) / (tan(KBD_TOP_A) - cotan(SCR_FRONT_A))
*/

kbd_back_x = (kbd_front_x * tan(KBD_TOP_A) - KBD_FRONT_Y - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y) / (tan(KBD_TOP_A) - cotan(SCR_FRONT_A));
kbd_back_y = kbd_back_x * tan(KBD_TOP_A) - kbd_front_x * tan(KBD_TOP_A) + KBD_FRONT_Y;

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

body_xy_plane();
