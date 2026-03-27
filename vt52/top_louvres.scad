include <common.scad>
include <body_dimensions.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

// Top bezel louvres

// Sheet 2, View E-E
TOP_LVR_WIDTH_Z = 4;
TOP_LVR_GAP_Z = 4;

// The round louvres at the end are NOT semi-circles, they are still TOP_LVR_WIDTH wide
TOP_LVR_R = 6.5;

// The louvres are offset from the terminal midline
TOP_LVR_MID_OFFSET_Z = -0.25;

// Sheet 2, Section AF-AF
TOP_LVR_TOP_BOT_WALL_Y = 4;
TOP_LVR_BACK_HOLE_X = 2; // offset from TOP_LVR_TOP_X, along X axis
TOP_LVR_BACK_WALL_X = 2; // offset from TOP_LVR_BACK_HOLE_X

TOP_LVR_DEPTH = 8; // custom, deep enough to punch through the front face

// Forward top edge of the louvres, including the gap
TOP_LVR_TOP_X = SCR_TOP_X; // 182
TOP_LVR_TOP_Y = SCR_TOP_Y; // 285

// Forward bottom edge of the louvres, including the gap
TOP_LVR_BOT_Y = SCR_FWD_TOP_Y; // 264

// TODO right side louvres are just holes through, left side have a backing

top_lvr_height_y = TOP_LVR_TOP_Y - 2 * TOP_LVR_TOP_BOT_WALL_Y - TOP_LVR_BOT_Y;

module one_top_louvre_rect(center_z) {
    bot_back = [
        TOP_LVR_TOP_X + TOP_LVR_BACK_HOLE_X,
        TOP_LVR_BOT_Y + TOP_LVR_TOP_BOT_WALL_Y,
        center_z
    ];

    size = [
        TOP_LVR_DEPTH,
        top_lvr_height_y,
        TOP_LVR_WIDTH_Z
    ];

    move(bot_back)
        cuboid(size, anchor = RIGHT + FRONT);
}

//one_top_louvre_rect(0);

module one_top_louvre_circ_left(center_z) {
    // The exact shape isn't very clear. View E-E says 6.5R, however that would not create a 4mm wide 10mm tall shape.
    //
    // The options are:
    //   1. Circle section 6.5R, 4mm wide but not 10mm tall; the drawings could be interpreted as slightly less than 10mm tall
    //   2. Circle section 6.5R, 10mm tall but not 4mm wide; but the width is explicitly defined by the drawing
    //   3. Circle section 40mm wide and 10mm tall but not 6.5R; but the radius is explicitly defined by the drawing
    //   4. Ellipse section with 6.5mm major axis, 40mm wide and 10mm tall; but the drawings don't mention an ellipse or the minor axis
    //
    // The louvre is also at an angle, so the shape isn't a clear circle section, relative to the angled surface.
    //
    // Left side of terminal (right side will be mirrored), model coordinates.

    // Cylinder, radius TOP_LVR_R, width TOP_LVR_WIDTH_Z, cut off from side to TOP_LVR_WIDTH_Z

    mid_back = [
        TOP_LVR_TOP_X + TOP_LVR_BACK_HOLE_X,
        (TOP_LVR_TOP_Y + TOP_LVR_BOT_Y) / 2,
        center_z
    ];

    move(mid_back) // move to place
        zmove(TOP_LVR_R - TOP_LVR_WIDTH_Z / 2) // center the cylinder section
            difference() {
                cylinder(h = TOP_LVR_DEPTH, r = TOP_LVR_R, orient = LEFT);

                // Cut of everything except a TOP_LVR_WIDTH_Z wide section
                move([DELTA, DELTA, TOP_LVR_WIDTH_Z])
                    cube([
                        TOP_LVR_DEPTH + 2 * DELTA,
                        2 * TOP_LVR_R + 2 * DELTA,
                        2 * TOP_LVR_R + 2 * DELTA
                    ], anchor = RIGHT);
            }
}

//one_top_louvre_circ_left(0);

// TODO remove
//include <body.scad>
//%body(true);

// module one_top_louvre_arc(center_z) {
//     move([SCR_LVR2_FWD_X, 0, center_z])
//         cuboid(
//             [SCR_LVR2_LENGTH_X, SCR_LVR_DEPTH, SCR_LVR2_WIDTH_Z],
//             anchor = LEFT + FRONT
//         );
// }

// module top_louvres() {
//     // Forward center
//     one_top_louvre_fwd(0);

//     for (i = [1:7]) {
//         offset_z = i * (SCR_LVR1_GAP_Z + SCR_LVR1_WIDTH_Z);
//         one_top_louvre_fwd(offset_z);
//         one_top_louvre_fwd(-offset_z);
//     }

//     // Forward sides
//     for (i = [0:1]) {
//         offset_z = SCR_LVR2_POS_Z + SCR_LVR1_WIDTH_Z / 2 + i * (SCR_LVR1_GAP_Z + SCR_LVR1_WIDTH_Z);
//         one_top_louvre_fwd(offset_z);
//         one_top_louvre_fwd(-offset_z);
//     }

//     // Back sides
//     offset_z = SCR_LVR2_POS_Z + SCR_LVR2_WIDTH_Z / 2;
//     one_top_louvre_back(offset_z);
//     one_top_louvre_back(-offset_z);
// }

// top_louvres();
