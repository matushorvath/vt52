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

YZ_TOP_CORNER_R = 20; // Sheet 6, Section AA-AA

// X values for YZ_* arrays below
YZ_X = [0, 50, 100, 150, 200];

// Approx. Z value at Y = BODY_Y ~= 285 including size of the rounded corner YZ_TOP_CORNER_R
YZ_TOP_HALF = [
    230.00, // X = 0; Sheet 31, Data List #3
    230.57, // X = 50; Sheet 31, Data List #4
    231.05, // X = 100; Sheet 31, Data List #5
    231.43, // X = 150; Sheet 31, Data List #6
    231.71, // X = 200; Sheet 31, Data List #7
];

// Approx. Z value at given X; Sheet 29, Data List #1
YZ_BOTTOM_HALF = [
    258.49, // X = 0
    259.91, // X = 50
    261.10, // X = 100
    262.06, // X = 150
    262.78, // X = 200
];

// VT50_FMPS, Sheet 5
ZX_FRONT_CORNER_R = 20; // Sheet 5, Bottom View H-H

// Empirically tuned to match keyboard front rounded corners to the body sides
KBD_FRONT_CORNER_ADJ_BOTTOM_Y = 0.55; // added to YZ_BOTTOM_HALF[0] when positioning bottom of the corner
KBD_FRONT_CORNER_ADJ_TOP_Y = 0.2; // additional shift when positioning top of the corner
