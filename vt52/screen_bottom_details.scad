include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

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

module bug_positive() {
    // Bug shape to remove from the screen mask, referenced from SCR_BUG_BACK_X

    // Calculate how much to shift the peak for the SCR_BUG_BACK_A angle
    add_shift_x = adj_ang_to_opp(SCR_BUG_HEIGHT, SCR_BOTTOM_A - SCR_BUG_BACK_A);

    xrot(-90)
        prismoid(
            size1 = [SCR_BUG_LENGTH, SCR_BUG_WIDTH_Z],
            size2 = [0, SCR_BUG_WIDTH_Z],
            shift = [SCR_BUG_LENGTH / 2 + add_shift_x, 0],
            h = SCR_BUG_HEIGHT,
            anchor = RIGHT + BOTTOM
        );
}

module bug_negative() {
    // Hole behind the bug to add to the screen mask, referenced from SCR_BUG_BACK_X

    length_x = scr_back_bottom_x - SCR_BUG_BACK_X + SCR_BUG_HOLE_EXTRA_X;

    xrot(-90)
        cuboid([
                length_x,               // from back end of the bug to screen bottom
                SCR_BUG_WIDTH_Z,        // same width as the bug
                SCR_BUG_HOLE_DEPTH      // punch through shell wall
            ],
            anchor = LEFT + TOP
        );
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
}

//screen_bottom_bezel_mask_flat();
