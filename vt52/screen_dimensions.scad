include <common.scad>
include <body_dimensions.scad>

// Sheet 2, View E-E
SCR_FRONT_TL_R = 12;
SCR_FRONT_TR_R = 5;
SCR_FRONT_BL_R = 5;
SCR_FRONT_BR_R = 5;

SCR_BACK_CORNER_A = 10;

SCR_FRONT_LEFT_Z = 222;
SCR_FRONT_RIGHT_Z = -48;
SCR_FRONT_CENTER_Z = 87;

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

// These refer to the actual LCD panel, without scaling
SCR_PANEL_UNSC_X = 165; // custom
SCR_PANEL_UNSC_Y = 120; // custom

// Margin for glue around the panel
SCR_PANEL_UNSC_MARGIN = 2.5; // custom

// Same values scaled up, so they get to the proper size when scaled down with the whole model
SCR_PANEL_X = SCR_PANEL_UNSC_X / SCALE;
SCR_PANEL_Y = SCR_PANEL_UNSC_Y / SCALE;
SCR_PANEL_MARGIN = SCR_PANEL_UNSC_MARGIN / SCALE;

// TODO define the step, is it 3 deep (tangential to the surface)? not clear in K-K
// update: it's probably the grey keyboard bezel
SCR_BOTTOM_STEP_X = 142;

SCR_BUG_WIDTH_Z = 4;
SCR_BUG_FAR_END_X = 194;
SCR_BUG_HEIGHT = 3; // height tangential to the surface, which is angled at SCR_BOTTOM_A

// TODO louvres on top of screen bezel, Sheet 4, View G-G

// TODO pattern on bottom of screen bezel, Sheet 8
//  - indentation right after keyboard starts Section CI-CI
//    - round corners 2.5R 2 places View I-I
//    - indentation depth .5 tangential, length 20 X, Section CG-CG
//  - ribs, 6 pieces, tangential to the complex shape
//    - defined in Section CF-CF (back) Section CH-CH (front, including the step for indentation)
//    - parallel with X
//      - try either BOSL2 placement, or maybe extrude a 2d shape without the side angles which makes it parallel with X
