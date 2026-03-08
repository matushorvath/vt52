include <common.scad>
include <BOSL2/std.scad>
include <BOSL2/trigonometry.scad>

// VT50_FMPS, Sheet 1
KBD_FRONT_Y = 13.5;
KBD_FRONT_A = 30;
KBD_TOP_A = 13;
KBD_BACK_R = 14;
SCR_FRONT_A = 12;
SCR_TOP_X = 182;

// VT50_FMPS, Sheet 2
BODY_Y = 282; // Section AF-AF

// Customizations
BODY_BACK_X = 300;

// Calculate missing coordinates
kbd_front_x = adj_ang_to_opp(KBD_FRONT_Y, KBD_FRONT_A);

/*
kbd_back_x and kbd_back_y are only defined by KBD_FRONT_A and KBD_TOP_A

tan(KBD_TOP_A) = (y - KBD_FRONT_Y) / (x - kbd_front_x)
x * tan(KBD_TOP_A) - kbd_front_x * tan(KBD_TOP_A) + KBD_FRONT_Y = y

cotan(SCR_FRONT_A) = (y - BODY_Y) / (x - SCR_TOP_X)
x * cotan(SCR_FRONT_A) - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y = y

x * tan(KBD_TOP_A) - kbd_front_x * tan(KBD_TOP_A) + KBD_FRONT_Y =
    x * cotan(SCR_FRONT_A) - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y

x * tan(KBD_TOP_A) - x * cotan(SCR_FRONT_A) =
    kbd_front_x * tan(KBD_TOP_A) - KBD_FRONT_Y - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y

x = (kbd_front_x * tan(KBD_TOP_A) - KBD_FRONT_Y - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y) / (tan(KBD_TOP_A) - cotan(SCR_FRONT_A))
*/

kbd_back_x = (kbd_front_x * tan(KBD_TOP_A) - KBD_FRONT_Y - SCR_TOP_X * cotan(SCR_FRONT_A) + BODY_Y) / (tan(KBD_TOP_A) - cotan(SCR_FRONT_A));
kbd_back_y = kbd_back_x * tan(KBD_TOP_A) - kbd_front_x * tan(KBD_TOP_A) + KBD_FRONT_Y;

// VT50_FMPS, Sheet 3, Sheet 19
// The YZ profile is slightly different for different X, see Figure 3 - Figure 16
// TODO use separate YZ profile values for different X
X182_TOP_HALF = 232.5 - 20; // Sheet 35, Data List #7, approx. Z value at Y = BODY_Y = 282; subtract X182_CORNER_R = 20
X182_BOTTOM_HALF = 262.5; // Sheet 29, Data List #1, approx. Z value at X = SCR_TOP_X = 182
X182_CORNER_R = 20; // Sheet 6, Section AA-AA
