include <common.scad>
include <body_tables.scad>
include <BOSL2/std.scad>

// VT50_FMPS, Sheet 1
KBD_FRONT_Y = 13.5;
KBD_FRONT_A = 30;
KBD_TOP_A = 13;
KBD_BACK_R = 14;
SCR_FRONT_A = 12;
SCR_TOP_X = 182;

// VT50_FMPS, Sheet 2
BODY_Y = 282; // Section AF-AF

// Depth of the model
BODY_BACK_X = 400; // custom

// Calculate missing coordinates
kbd_front_x = adj_ang_to_opp(KBD_FRONT_Y, KBD_FRONT_A);

/* Top back point of the keyboard
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
YZ_X = [0, 50, 100, 150, 200, 250, 300, 350, 400];

// Approx. Z value at Y = BODY_Y ~= 285 including size of the rounded corner YZ_TOP_CORNER_R
YZ_TOP_HALF = [
    YZ_CURVE_X000[0][1],    // X = 0; Sheet 31, Data List #3
    YZ_CURVE_X050[0][1],    // X = 50; Sheet 32, Data List #4
    YZ_CURVE_X100[0][1],    // X = 100; Sheet 33, Data List #5
    YZ_CURVE_X150[0][1],    // X = 150; Sheet 34, Data List #6
    YZ_CURVE_X200[0][1],    // X = 200; Sheet 35, Data List #7
    YZ_CURVE_X250[0][1],    // X = 250; Sheet 36, Data List #8
    YZ_CURVE_X300[0][1],    // X = 300; Sheet 37, Data List #9
    YZ_CURVE_X350[0][1],    // X = 350; Sheet 38, Data List #10
    YZ_CURVE_X400[0][1],    // X = 400; Sheet 39, Data List #11
];

// Approx. Z value at given X; Sheet 29, Data List #1
YZ_BOTTOM_HALF = [
    258.50000,  // X = 0
    259.92857,  // X = 50
    261.11905,  // X = 100
    262.07143,  // X = 150
    262.78571,  // X = 200
    263.26191,  // X = 250
    263.50000,  // X = 300
    263.50000,  // X = 350
    263.29190,  // X = 400
];

// VT50_FMPS, Sheet 5
ZX_FRONT_CORNER_R = 20; // Sheet 5, Bottom View H-H

// Empirically tuned to match keyboard front rounded corners to the body sides
KBD_FRONT_CORNER_ADJ_BOTTOM_Y = 0.55; // added to YZ_BOTTOM_HALF[0] when positioning bottom of the corner
KBD_FRONT_CORNER_ADJ_TOP_Y = 0.2; // additional shift when positioning top of the corner

// Decorative bezel on cerain edges
// Sheet 2, Section AD-AD, Section AE-AE, Section AH-AH
// TODO apply decorative bezel
//  - front top edge of keyboard AD-AD
//  - side edges of the keyboard !REF
//  - front top edge of the body AE-AE
//  - side edges of the body AH-AH
DEC_BEZEL_HEIGHT = .75;
DEC_BEZEL_R = 1.5;
