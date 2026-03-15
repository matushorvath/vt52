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

// Bug
SCR_BUG_WIDTH_Z = 4;
SCR_BUG_FAR_END_X = 194;
SCR_BUG_HEIGHT = 3; // height tangential to the surface, which is angled at SCR_BOTTOM_A

// Indent; Sheet 8, View I-I
SCR_INDENT_LEFT_Z = 229.9 - 4.77 - 12;
SCR_INDENT_WIDTH_Z = 219;
scr_indent_right_z = SCR_INDENT_LEFT_Z + SCR_INDENT_WIDTH_Z;

SCR_INDENT_BACK_X = 26.86 + 99.27 + 20;
SCR_INDENT_DEPTH = 0.5; // Sheet 8, Section CG-CG

SCR_INDENT_CORNER_R = 2.5;

// Ribs

// Offsets from SCR_INDENT_LEFT_Z; Sheet 8, View I-I
SCR_RIB_1_OFFSET_Z = 19.05;
SCR_RIB_2_OFFSET_Z = SCR_RIB_1_OFFSET_Z + 38.1;
SCR_RIB_3_OFFSET_Z = SCR_RIB_2_OFFSET_Z + 38.1;
SCR_RIB_4_OFFSET_Z = SCR_RIB_3_OFFSET_Z + 38.1;
SCR_RIB_5_OFFSET_Z = SCR_RIB_4_OFFSET_Z + 38.1;
SCR_RIB_6_OFFSET_Z = SCR_RIB_5_OFFSET_Z + 38.1;

// Sheet 8, Section CF-CF, Section CH-CH
SCR_RIB_CORNER_R = 0.25;
SCR_RIB_DEPTH = 1.0;
SCR_RIB_WIDTH = 1.0;
// Ribs in the indent have additional depth of SCR_INDENT_DEPTH
