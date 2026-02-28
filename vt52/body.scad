include <common.scad>
include <BOSL2/shapes2d.scad>
include <BOSL2/trigonometry.scad>
include <BOSL2/utility.scad>

// VT50_FMPS, Sheet 1

BODY_Y = 282;
KBD_FRONT_Y = 13.5;
KBD_FRONT_A = 30;
KBD_TOP_A = 13;
KBD_BACK_R = 14;
SCR_FRONT_A = 12;
SCR_TOP_X = 182;

// Customizations
BODY_X = 300;

module body_xy_plane() {
    polygon([
        [0, 0],                                                                         // keyboard front bottom
        [adj_ang_to_opp(KBD_FRONT_Y, KBD_FRONT_A), KBD_FRONT_Y],                        // keyboard front top
        // TODO SCR_TOP_X is too far, but the exact point is only defined by angles KBD_FRONT_A and KBD_TOP_A
        [SCR_TOP_X, KBD_FRONT_Y + adj_ang_to_opp(SCR_TOP_X, KBD_TOP_A)],   // keyboard back top
        [SCR_TOP_X, 0]                                                                  // keyboard back top
    ]);
}

body_xy_plane();
