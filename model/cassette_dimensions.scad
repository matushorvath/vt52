// include
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
// Bottom back edge of the cover is at Y = kbd_back_y = 41.78.
// Cover height is CC_HEIGHT = 230.5, angled at SCR_FWD_A = 12.
// Cover height in Y is CC_HEIGHT * cos(SCR_FWD_A) = 225,46.
// Top edge of the cover is then at Y = kbd_back_y + 225,46 = 267.24.
// Top edge of the screen is defined as SCR_FWD_TOP_Y = 264, which is 3.2 mm lower.
// The bottom edge of the cover is angled (Page 6, Item #2), that explains about 0.8 mm in Y direction.
// That makes the cover about 2.4 mm larger than the screen viewport,
// suggesting the margins (CC_COVER_MARGIN) are about 1.2 mm.
//
// The photos seem to show the cover slightly taller than the screen viewport.
// Even photos taken from above, where parallax is not an issue.
// The space at the bottom of the louvres (Section AF-AF) is 4 mm,
// and the cover looks like it hides about one quarter of that.
//
// Decision: Cover mask has the exact vertical location of the screen viewport.
// Cover itself is 1 mm larger than the mask in every direction except bottom (CC_COVER_MARGIN).
// Cover corners are same as screen corners, do NOT add 1 mm to their radius.
// Cover is supported by the mask on all sides, with four tabs holding it in.

// Cover bottom discussion:
//
// Based on YouTube videos, the cover very slightly overlaps the hole and it rises perhaps
// 1 mm over the screen surface. It is not completely embedded in the body.
// Based on the videos and on higher res pictures, there is something strange going on with
// borders of the body hole at the bottom, where it touches the kbd/scr fillet.
// There is a discontinuity.
//
// The rounded corners at the bottom are R5 and match the R5 hole in the body.
// The kbd/scr fillet is R14, which means the corners interfere with top of the fillet.
// This is solved by masking of the part of the fillet that interferes with the back side
// of the corners, which is the "something strange" in the pictures.
//
// Specifically, what interferes is the back side of the outside corners of the bottom notches.
// The fillet is already moving away from the screen plane here. Also, the outside corners are
// definitely 90 degrees to the rest of the cover in all directions.
//
// Decision:
// The notches at the bottom of the cover are creating an overlap over screen plane,
// 1 mm wide on all sides except bottom. Cover bottom sits on keyboard top plane.
// In order to solve the interference between R5 and R14 shapes, top of the R14 fillet
// will be masked off to be in screen plane, allowing space for outside bottom corners
// of the cover.

// Page 6, Sheet 1, Cassette Cover

// These are unused (see discussion above), instead we derive them from body dimensions
// CC_HEIGHT = 230.5;
// CC_WIDTH_Z = 166;

// Depth of the cover above screen plane
CC_VISIBLE_DEPTH = 1; // estimated

// Difference between cover size and mask size; custom
CC_COVER_MARGIN = 1;

// Handle

// Space left and right of the handle; estimated from photos
CC_HANDLE_MARGIN_Z = 1;

// Top of the cover to bottom of the handle
CC_HANDLE_POS = 205;

// Visible handle depth; partly from drawings and partly estimated
CC_HANDLE_DEPTH = 12; // custom; original is (20 - estimated 4)

CC_HANDLE_HEIGHT = 2; // estimated

// Handle corner rounding; custom
CC_HANDLE_R = 1;

// Page 13, Sheet 2, Shell VT50, View E-E

// Let's use the screen constants to make sure they are kept in sync
CC_TR_R = SCR_FWD_TL_R;
CC_TL_R = SCR_FWD_TR_R;
CC_B_R = SCR_FWD_BR_R;

// This does not match CC_WIDTH_Z, the difference is 6.5 mm, that's why we don't use CC_WIDTH_Z
CC_MASK_LEFT_Z = 63;
CC_MASK_RIGHT_Z = 222.5;
cc_mask_width = CC_MASK_RIGHT_Z - CC_MASK_LEFT_Z;
