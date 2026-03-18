include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

// TODO add front bezel border ? if it exists
// TODO louvres on top of screen bezel, Sheet 4, View G-G

module rib(length) {
    // TODO edge rounding
    xrot(90)
        prismoid(
            size1 = [length, SCR_RIB_WIDTH],
            size2 = [length, 0],
            h = SCR_RIB_DEPTH,
            anchor = LEFT + BOTTOM
        );
}

module six_ribs(length) {
    zmove(SCR_RIB_1_OFFSET_Z) rib(length);
    zmove(SCR_RIB_2_OFFSET_Z) rib(length);
    zmove(SCR_RIB_3_OFFSET_Z) rib(length);
    zmove(SCR_RIB_4_OFFSET_Z) rib(length);
    zmove(SCR_RIB_5_OFFSET_Z) rib(length);
    zmove(SCR_RIB_6_OFFSET_Z) rib(length);
}

module screen_bottom_bezel_mask_flat() {
    // Bottom bezel features referenced from SCR_INDENT_FWD_X, SCR_INDENT_LEFT_Z (forward left corner of the indent)

    // Indent
    cuboid(
        [SCR_INDENT_LENGTH_X, SCR_INDENT_DEPTH, SCR_INDENT_WIDTH_Z],
        anchor = BACK + LEFT + BOTTOM,
        edges = [TOP + RIGHT, BOTTOM + RIGHT],
        rounding = SCR_INDENT_CORNER_R
    );

    // Ribs through the indent
    ymove(-SCR_INDENT_DEPTH + DELTA)
        six_ribs(SCR_INDENT_LENGTH_X);

    // Ribs beyond the indent
    xmove(SCR_INDENT_LENGTH_X - DELTA)
        six_ribs(scr_rib_back_x - SCR_INDENT_FWD_X - SCR_INDENT_LENGTH_X);

    // TODO add the bug
}

screen_bottom_bezel_mask_flat();
