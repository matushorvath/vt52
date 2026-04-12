include <common.scad>
include <body_dimensions.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

// "Cassette cover", dark cover on the right side of the screen

// Notes:
//
// The bottom edge of the original cover probably rests on the keyboard plane, in the model
// we instead fully support it from the back on all sides, since it's easier.

// Cover height discussion:
//
// Bottom edge of the cover (and screen) is at Y = kbd_back_y = 41.78.
// Cover height is CC_HEIGHT = 230.5, angled at SCR_FWD_A = 12.
// Cover height in Y is CC_HEIGHT * cos(SCR_FWD_A) = 225,46.
// Top edge of the cover is then at Y = kbd_back_y + 225,46 = 267.24.
// Top edge of the screen is defined as SCR_FWD_TOP_Y = 264, which is 3.2 mm lower.
// The bottom edge of the cover is angled (Page 6, Item #2), that explains about 0.4 mm in Y direction.
// That still makes the cover about 2.5 mm larger than the screen viewport.
// Also, CC_HEIGHT is defined as REF, so it's not exact.
//
// The photos seem to show the cover slightly taller than the screen viewport.
// Even photos taken from above, where parallax is not an issue.
// The space at the bottom of the louvres (Section AF-AF) is 4 mm,
// and the cover looks like it hides about one quarter of that.
//
// Decision: Cover hole has the exact vertical location of the screen viewport.
// Cover itself is 1 mm larger than the hole in every direction except bottom (CC_COVER_MARGIN).
// Cover corners are same as screen corners, do NOT add 1 mm to their radius.
// Bottom of the cover hole is flat, no rounded corners, matching the position of the
// bottom two notches on the cover, which are CC_B_R = 5 mm from the bottom.
// Cover is supported by the hole on all sides, with four tabs holding it in.

// Page 6, Sheet 1, Cassette Cover

// These are unused (see discussion above), instead we derive them from body dimensions
// CC_HEIGHT = 230.5;
// CC_WIDTH_Z = 166;

// Depth of the cover above screen plane
CC_VISIBLE_DEPTH = 2;

// Difference between cover size and hole size; custom
CC_COVER_MARGIN = 1;

// Handle

// Space left and right of the handle
CC_HANDLE_MARGIN_Z = 4;

// Top of the cover to bottom of the handle
CC_HANDLE_POS = 205;

// Forward of the handle to back of the cover, since that's defined by the drawings
CC_HANDLE_TOTAL_DEPTH = 20;
// Actual visible handle depth, without depth of the cover
cc_handle_depth = CC_HANDLE_TOTAL_DEPTH - 4; // estimated cover depth, 4 = CC_VISIBLE_DEPTH(=2) + 2

CC_HANDLE_HEIGHT = 2; // estimated

// Page 13, Sheet 2, Shell VT50, View E-E

// Let's use the screen constants to make sure they are kept in sync
CC_TR_R = SCR_FWD_TL_R;
CC_TL_R = SCR_FWD_TR_R;
CC_B_R = SCR_FWD_BR_R;

// This does not match CC_WIDTH_Z, the difference is 6.5 mm, that's why we don't use CC_WIDTH_Z
CC_HOLE_LEFT_Z = 63;
CC_HOLE_RIGHT_Z = 222.5;
//cc_hole_center_z = (CC_HOLE_LEFT_Z + CC_HOLE_RIGHT_Z) / 2; TODO uncomment or delete
cc_hole_width = CC_HOLE_RIGHT_Z - CC_HOLE_LEFT_Z;

// Hole top is be the same as screen viewport top; estimated
// See discussion above
// TODO use scr directly, delete this
// cc_top_x = scr_fwd_top_x;
// CC_TOP_Y = SCR_FWD_TOP_Y;
