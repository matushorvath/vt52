// include
include <common.scad>
include <BOSL2/std.scad>

// Page 61, Sheet 2 of 2

// My copy of the document doesn't have Sheet 1 of 2, also it seems I either don't completely understand
// this drawing, or it has some errors. For example, the X, Y and Z axes seem to be mixed up in many places.
// This model is my best attempt at interpretating an incomplete drawing.

// The comments and variable names below use the same coordinate system as the shell, which isn't consistent
// with Page 61. Sitting at the terminal, front to back is X, bottom to top is Y, right to left is Z.

// Base height from top of the feet to bottom of the lip
BASE_Y = 60; // Page 61; height with half-lip 65 - half-lip 5

// Side radius of the base
BASE_R = 18.5;

// Parameters in Section E-E
BASE_EE_X = 24.5;
base_ee_y = BASE_R; // height of the base, same as side radius
BASE_EE_A = 30; // side angle of the base

// Parameters in Section F-F
BASE_FF_X = 241.8;
base_ff_y = BASE_Y; // height of the base, full height
BASE_FF_A = 15; // side angle of the base

// Lip around the top of the base, where it connects to shell
// TODO lip has more complex geometry
BASE_LIP_Y = 10;

// TODO base
// - use data table 1
// - model before E-E
// - design a curve to seamlessly connect to E-E and F-F, use the curve for height_y
// - model after F-F
// - add internal mask
// - add lip
// - add feet
// - add mounting to shell
// - add stiffening ribs
// - mount keyboard, various boards, maybe connectors at the back for USB/HDMI extensions
// - decide if we need more of data table 1 for the curves to look contiguous (we have just 6 values)
