include <common.scad>
include <body_dimensions.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

// "Cassette cover", dark cover on the right side of the screen

// Page 6, Sheet 1, Cassette Cover

CC_HEIGHT = 230.5;
CC_WIDTH_Z = 166;
CC_VISIBLE_DEPTH = 2; // estimated, TODO photos look more like 1

// Space left and right of the handle
CC_HANDLE_MARGIN_Z = 4;

// Top of the cover to bottom of the handle
CC_HANDLE_POS = 205;

// Forward of the handle to back of the cover
CC_HANDLE_TOTAL_DEPTH = 20;
cc_handle_depth = CC_HANDLE_TOTAL_DEPTH - 4; // estimated cover depth, 4 = CC_VISIBLE_DEPTH(=2) + 2

CC_HANDLE_HEIGHT = 2; // estimated

// Cover dimensions vs hole dimensions, estimated differences:
CC_TOP_MARGIN = 5;
CC_SIDE_MARGIN = 3; // TODO perhaps 2 on the right side?
CC_BOT_MARGIN = 8;

// Page 13, Sheet 2, Shell VT50, View E-E

// Let's use the screen constants to make sure they are kept in sync
CC_TR_R = SCR_FWD_TL_R;
CC_TL_R = SCR_FWD_TR_R;
CC_BR_R = SCR_FWD_BL_R;
CC_BL_R = SCR_FWD_BR_R;

// There's a small step next to the bottom radiuses
CC_BOT_STEP = 1.5; // estimated

// This does not match CC_WIDTH_Z, because the hole in body is smaller than the cover
CC_LEFT_Z = 63;
CC_RIGHT_Z = 222.5;
cc_center_z = (CC_LEFT_Z + CC_RIGHT_Z) / 2;

// Top position will be the same as screen viewport; estimated
// That also means the cover is slightly taller than screen viewport, by CC_TOP_MARGIN
// TODO higher by CC_TOP_MARGIN, 5 mm, is certainly wrong, that's half louvre height
//  - top edge in DECscope-4.jpg looks lower than top screen edge, perhaps 1 mm
//  - probably we need to ignore the dotted lines in Page 6, Sheet 1, Object 1, it's anyway a sus diagram
//  - MP00036_VT50_Maintenance_Drawings_Jan1976 Page 3 has a border around the hole and it looks a bit bigger than viewport
CC_TOP_Y = SCR_FWD_TOP_Y;
cc_top_y = scr_fwd_top_x;

// Bottom position will NOT be the same as screen viewport
// TODO find out bottom cover position, perhaps from cover height and top/bot margins

// TODO some way to attach the cover; MP00036_VT50_Maintenance_Drawings_Jan1976 Page 3 has four notches

// TODO Sheet 2, Section AI-AI: Body hole sides are angled 3 degrees inward
// TODO Sheet 4, View G-G: A slightly recessed area in front of the cover similar to the area in front of screen?
