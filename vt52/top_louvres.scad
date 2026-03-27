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
TOP_LVR_MID_OFFSET_Z = 0.25;

// Sheet 2, Section AF-AF
TOP_LVR_TOP_BOT_WALL_Y = 4;
TOP_LVR_BACK_HOLE_X = 2; // offset from TOP_LVR_TOP_X, along X axis
TOP_LVR_BACK_WALL_X = 2; // offset from TOP_LVR_BACK_HOLE_X

TOP_LVR_DEPTH = 8; // custom, deep enough to punch through the front face
TOP_LVR_EXTRA_CORE_X = 4; // extra X depth for louvres without the backing

// Forward top edge of the louvres, including the gap
TOP_LVR_TOP_X = SCR_TOP_X; // 182
TOP_LVR_TOP_Y = SCR_TOP_Y; // 285

// Forward bottom edge of the louvres, including the gap
TOP_LVR_BOT_Y = SCR_FWD_TOP_Y; // 264

// Louvres should be cored through between Z=63 and Z=222.5; Sheet 2, View E-E
TOP_LVR_BLIND_L = 28; // number of blind louvres to the left; all of them
TOP_LVR_BLIND_R = 8; // number of blind louvres to the right

top_lvr_height_y = TOP_LVR_TOP_Y - 2 * TOP_LVR_TOP_BOT_WALL_Y - TOP_LVR_BOT_Y;

module one_top_louvre_rect(center_z, core) {
    // Louvres that go through need to go deeper than TOP_LVR_BACK_HOLE_Xs
    extra_x = core ? TOP_LVR_EXTRA_CORE_X : 0;

    bot_back = [
        TOP_LVR_TOP_X + TOP_LVR_BACK_HOLE_X + extra_x,
        TOP_LVR_BOT_Y + TOP_LVR_TOP_BOT_WALL_Y,
        center_z
    ];

    size = [
        TOP_LVR_DEPTH + extra_x,
        top_lvr_height_y,
        TOP_LVR_WIDTH_Z
    ];

    move(bot_back)
        cuboid(size, anchor = RIGHT + FRONT);
}

//one_top_louvre_rect(0);

module one_top_louvre_arc_left(center_z, core) {
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

    // Louvres that go through need to go deeper than TOP_LVR_BACK_HOLE_Xs
    extra_x = core ? TOP_LVR_EXTRA_CORE_X : 0;

    // Cylinder, radius TOP_LVR_R, width TOP_LVR_WIDTH_Z, cut off from side to TOP_LVR_WIDTH_Z
    mid_back = [
        TOP_LVR_TOP_X + TOP_LVR_BACK_HOLE_X + extra_x,
        (TOP_LVR_TOP_Y + TOP_LVR_BOT_Y) / 2,
        center_z
    ];

    move(mid_back) // move to place
        zmove(TOP_LVR_R - TOP_LVR_WIDTH_Z / 2) // center the cylinder section
            difference() {
                cylinder(h = TOP_LVR_DEPTH + extra_x, r = TOP_LVR_R, orient = LEFT);

                // Cut of everything except a TOP_LVR_WIDTH_Z wide section
                move([DELTA, DELTA, TOP_LVR_WIDTH_Z])
                    cube([
                        TOP_LVR_DEPTH + 2 * DELTA + extra_x,
                        2 * TOP_LVR_R + 2 * DELTA,
                        2 * TOP_LVR_R + 2 * DELTA
                    ], anchor = RIGHT);
            }
}

//one_top_louvre_arc_left(0);

module top_louvres_mask() {
    for (i = [0:26]) {
        offset_z = TOP_LVR_MID_OFFSET_Z
            + TOP_LVR_GAP_Z / 2
            + i * (TOP_LVR_GAP_Z + TOP_LVR_WIDTH_Z)
            + TOP_LVR_WIDTH_Z / 2;

        one_top_louvre_rect(-offset_z, i >= TOP_LVR_BLIND_L);
        one_top_louvre_rect(offset_z, i >= TOP_LVR_BLIND_R);
    }

    offset_z = TOP_LVR_MID_OFFSET_Z
        + TOP_LVR_GAP_Z / 2
        + 27 * (TOP_LVR_GAP_Z + TOP_LVR_WIDTH_Z)
        + TOP_LVR_WIDTH_Z / 2;

    one_top_louvre_arc_left(-offset_z, false);

    zflip(z = TOP_LVR_MID_OFFSET_Z)
        one_top_louvre_arc_left(-offset_z, true);
}

//#top_louvres();

module top_louvres_backing() {
    // We add a backing to the louvres that should not be cored through
    // No need to add the whole top wall, since the shell is already there
    // (and we can avoid having to model a round shape in the corners)

    left_z = -TOP_LVR_BLIND_L * (TOP_LVR_GAP_Z + TOP_LVR_WIDTH_Z); // TOP_LVR_BLIND_L-th louvre left
    right_z = TOP_LVR_BLIND_R * (TOP_LVR_GAP_Z + TOP_LVR_WIDTH_Z); // TOP_LVR_BLIND_R-th louvre right

    move([
        TOP_LVR_TOP_X + TOP_LVR_BACK_HOLE_X - DELTA, // bottom of the louvre
        TOP_LVR_BOT_Y, // top of the screen/bottom of the louvre box
        left_z
    ])
        cube([
            TOP_LVR_BACK_WALL_X,
            TOP_LVR_TOP_Y - TOP_LVR_BOT_Y - BODY_WALL + DELTA,
            right_z - left_z
        ]);
}

//top_louvres_backing();

// include <body.scad>
// %body(true);
