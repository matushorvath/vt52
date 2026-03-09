include <common.scad>
include <body_dimensions.scad>

// Sheet 2, View E-E
SCR_FRONT_TL_A = 12;
SCR_FRONT_TR_A = 5;
SCR_FRONT_BL_A = 5;
SCR_FRONT_BR_A = 5;

SCR_BACK_CORNER_A = 10;

SCR_FRONT_LEFT_Z = 222;
SCR_FRONT_RIGHT_Z = -48;
SCR_FRONT_CENTER_Z = 87;

SCR_BUG_WIDTH_Z = 4;
SCR_BUG_FAR_END_X = 194;
SCR_BUG_HEIGHT = 3; // height tangential to the surface, which is angled at SCR_BOTTOM_A

// Sheet 2, View K-K
SCR_FRONT_TOP_Y = 264;
// SCR_FRONT_BOTTOM_Y is defined by kbd_back_x, kbd_back_y

SCR_TOP_A = 22;
SCR_BOTTOM_A = KBD_TOP_A;
SCR_SIDE_A = 6; // Section AG-AG

// These refer to the midpoint of the screen
SCR_BACK_SCREEN_A = 16;
SCR_BACK_SCREEN_X = 218;
SCR_BACK_SCREEN_Y = 148;

// TODO define the step, is it 3 deep (tangential to the surface)? not clear in K-K
SCR_BOTTOM_STEP_X = 142;

// TODO louvres on top of screen bezel, Sheet 4, View G-G
