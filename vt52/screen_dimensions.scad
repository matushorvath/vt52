include <common.scad>
include <body_dimensions.scad>

// Screen viewport forward surface

// Sheet 2, View E-E
SCR_FWD_TL_R = 12;
SCR_FWD_TR_R = 5;
SCR_FWD_BL_R = 5;
SCR_FWD_BR_R = 5;

SCR_FWD_LEFT_Z = 222;
SCR_FWD_RIGHT_Z = -48;
scr_fwd_center_z = (SCR_FWD_LEFT_Z + SCR_FWD_RIGHT_Z) / 2;

// Sheet 2, View K-K
scr_fwd_bottom_x = kbd_back_x;
scr_fwd_bottom_y = kbd_back_y;

SCR_FWD_TOP_Y = 264;
scr_fwd_top_x = scr_fwd_bottom_x + tan(SCR_FWD_A) * (SCR_FWD_TOP_Y - scr_fwd_bottom_y);

scr_fwd_center_x = (scr_fwd_bottom_x + scr_fwd_top_x) / 2;
//scr_fwd_center_y = (scr_fwd_bottom_y + SCR_FWD_TOP_Y) / 2;

// Calculate forward plane dimensions
scr_fwd_height = SCR_FWD_TOP_Y - scr_fwd_bottom_y;
scr_fwd_width = SCR_FWD_LEFT_Z - SCR_FWD_RIGHT_Z;

// Screen viewport sides

// Bezel side angles
// SCR_TOP_A = 22; // unused, defined by forward and back surfaces
SCR_BOTTOM_A = KBD_TOP_A; // bottom bezel side just continues at the keyboard angle
// SCR_SIDE_A = 6; // Section AG-AG // unused, defined by forward and back surfaces

// Screen viewport back surface

// Sheet 2, View E-E
SCR_BACK_CORNER_A = 10;

// Sheet 2, View K-K
SCR_BACK_A = 16;
SCR_BACK_CENTER_X = 218; // can be customized to move the screen in or out
// SCR_BACK_CENTER_Y = 148; // unused, constrained by other coordinates (see scr_back_center_y)

// These refer to the actual LCD panel, without scaling
SCR_PANEL_UNSC_X = 165; // custom
SCR_PANEL_UNSC_Y = 120; // custom

// Margin for glue around the panel
SCR_PANEL_UNSC_MARGIN = 2.5; // custom

// Same values scaled up, so they get to the proper size when scaled down with the whole model
SCR_PANEL_X = SCR_PANEL_UNSC_X / SCALE;
SCR_PANEL_Y = SCR_PANEL_UNSC_Y / SCALE;
SCR_PANEL_MARGIN = SCR_PANEL_UNSC_MARGIN / SCALE;

// Make the back surface slightly smaller than the panel
SCR_BACK_WIDTH = SCR_PANEL_X - 2 * SCR_PANEL_MARGIN;
SCR_BACK_HEIGHT = SCR_PANEL_Y - 2 * SCR_PANEL_MARGIN;

// The X coordinate of the back surface center plus the angle and height of the back surface
// fully define the X coordinate of the back surface bottom point.
scr_back_bottom_x = SCR_BACK_CENTER_X - (SCR_BACK_HEIGHT / 2) * sin(SCR_BACK_A);

// The Y coordinate of the back surface bottom point is defined by the bottom screen bezel.
// tan(SCR_BOTTOM_A) = (scr_back_bottom_y - scr_fwd_bottom_y) / (scr_back_bottom_x - scr_fwd_bottom_x)
scr_back_bottom_y = tan(SCR_BOTTOM_A) * (scr_back_bottom_x - scr_fwd_bottom_x) + scr_fwd_bottom_y;

scr_back_center_y = scr_back_bottom_y + cotan(SCR_BACK_A) * (SCR_BACK_CENTER_X - scr_back_bottom_x);

// Screen viewport extra surface (for clearing the keyboard/screen fillet)

// Calculate how to extend the forward plane more to front, to mask the keyboard/screen fillet
scr_extra_dist_x = KBD_BACK_R * 2; // double the fillet to make sure we clear it, the fillet is at an angle, so slightly wider in X than KBD_BACK_R
scr_extra_ratio = scr_extra_dist_x / (SCR_BACK_CENTER_X - scr_fwd_center_x); // TODO separate top/bottom ratios, at least for radiuses?

scr_extra_width = scr_fwd_width + (scr_fwd_width - SCR_BACK_WIDTH) * scr_extra_ratio;
scr_extra_height = scr_fwd_height + (scr_fwd_height - SCR_BACK_HEIGHT) * scr_extra_ratio;

scr_extra_bottom_x = scr_fwd_bottom_x - scr_extra_dist_x;
scr_extra_bottom_y = scr_fwd_bottom_y + (scr_fwd_bottom_y - scr_back_bottom_y) * scr_extra_ratio;

// Screen viewport details

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
//    - defined in Section CF-CF (back) Section CH-CH (forward, including the step for indentation)
//    - parallel with X
//      - try either BOSL2 placement, or maybe extrude a 2d shape without the side angles which makes it parallel with X
