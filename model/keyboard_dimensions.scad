include <common.scad>
include <BOSL2/std.scad>

// Keyboard: Royal Kludge R65 (RK-R65-R14BKM)

// Model coordinates (operator is looking at the keyboard in X direction)
// Real keyboard sizes, not scaled

// Board dimensions, without dampers and mounting holes
K65_BOARD_X = 98;
K65_BOARD_Z = 308;

// Keyboard bottom to top of the board; at least 9.5; board w/o connectors is 6.5
K65_BOARD_Y = 10;

// Top of the board to bottom of key caps + about 1 mm extra
// = how much above K65_BOARD_Y is inside the body
K65_HIDDEN_Y = 6.5;

// Extra height above K65_HIDDEN_Y, to clear the keyboard top plane; custom
K65_MASK_EXTRA_Y = 10;

// One keycap size (including space between keys)
K65_KEYCAP_SIZE = 19;
// Extra margin around the keycap area
K65_KEYCAP_MARGIN = 2;

// Key mask size
k65_keys_mask_size = [
    5 * K65_KEYCAP_SIZE + K65_KEYCAP_MARGIN,
    16 * K65_KEYCAP_SIZE + K65_KEYCAP_MARGIN
];

// Damper size
K65_DAMPER_X = 5;
K65_DAMPER_Y = 6.5;
K65_DAMPER_Z = 40;

// Width of the board including dampers in X (K65_BOARD_X + 2 * damper extra X)
K65_TOTAL_X = 106;

// Dampers are slightly embedded in the board in X, calculate how much
k65_damper_center_to_center_x = K65_TOTAL_X - 2 * K65_DAMPER_X / 2;
k65_damper_attach_x = (K65_BOARD_X - k65_damper_center_to_center_x) / 2;

// Center of damper in Y is attached 0.75 from board top (K65_BOARD_Y)
K65_DAMPER_ATTACH_Y = 0.75;

// Centers of dampers in Z measured from board center, symmetrical except the one near backspace
K65_DAMPER_ATTACH_IN_Z = 43.5;
K65_DAMPER_ATTACH_OUT_Z = 130;
K65_DAMPER_ATTACH_BSPC_Z = 120;

// Space before the keyboard, in direction of KBD_TOP_A
K65_FRONT_MARGIN = 4;

// Position shift in Z, to place the keyboard off-center like the original
K65_OFF_CENTER_Z = 12; // 10 is ALMOST aligned with the corner rounding, which looks strange
