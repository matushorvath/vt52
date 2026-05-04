// include
include <common.scad>
include <BOSL2/std.scad>

// Page 61, Sheet 2 of 2

// My copy of the document doesn't have Sheet 1 of 2, also it seems I either don't completely understand
// this drawing, or it has some errors. For example, the X, Y and Z axes seem to be mixed up in many places.
// This model is my best attempt at interpretating an incomplete drawing.

// The comments and variable names below use the same coordinate system as the shell, which isn't consistent
// with Page 61. Sitting at the terminal, front to back is X, bottom to top is Y, right to left is Z.

// Continuity before E-E and after E-E discussion:
//
// Blending the vertical 18.5R to the horizontal 18.5R while also keeping the curve contiguous was likely
// not defined analytically in the drawing, even if I had the whole drawing, which I don't.
// It was likely done by sculpting the shape until it looked good. The same for the bottom curve between
// E-E and F-F, which is also either not defined or I don't have the definition.

// Base height from top of the feet to bottom of the lip
BASE_Y = 60; // Page 61; height with half-lip 65 - half-lip 5

// Side radius of the base
BASE_R = 18.5;

// Parameters in Section E-E
BASE_EE_X = 24.5;
base_ee_y = BASE_Y / 2; // height of the base at E-E; estimated
BASE_EE_A = 30; // side angle of the base

// Parameters in Section F-F
BASE_FF_X = 241.8; // TODO this probably needs to be more forward in shortened model
base_ff_y = BASE_Y; // height of the base, full height
BASE_FF_A = 15; // side angle of the base

// Gap between each two slices between E-E and F-F
BASE_EE_FF_STEP_X = 10;

// Radius of the circle section curve between E-E and F-F
base_ee_ff_x = BASE_FF_X - BASE_EE_X;
base_ee_ff_y = base_ff_y - base_ee_y;
base_curve_ee_ff_r = (base_ee_ff_x^2 + base_ee_ff_y^2) / (2 * base_ee_ff_y);

// Tangent angle at E-E
// TODO verify/remove BASE_TANGENT_EE_A = arcsin(base_ee_ff_x / base_curve_ee_ff_r);

// Lip around the top of the base, where it connects to shell
// TODO lip has more complex geometry
BASE_LIP_Y = 10;

// TODO base
// - model the 0-EE shape
// - extend the keyboard section of base to match the extended shell (for real-world keyboard)
// - add lip
// - add feet
// - add mounting to shell
// - add stiffening ribs
// - mount keyboard, various boards, maybe connectors at the back for USB/HDMI extensions
