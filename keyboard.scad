include <common.scad>
include <BOSL2/std.scad>


// TODO
// - body of the keyboard
//   - pin holes
// - angle the keyboard by KBD_TOP_A
// - design mounting hardware
//   - pins for the holes, they will be fragile, stiffen them
//   - rests for the dampers, top and bottom
//   - perhaps brackets for the corners? but not too close
// - locate the keyboard in body
// - find if bottom needs to be adjusted to fit

// - try to use the soft foam and silicon that was below the keyboard
// - don't forget about the USB board
//   - USB board connects between left shift and Z

// - add positive mounting features
//   - but also, how mounting features will attach to the body depends on keyboard position
//   - perhaps add the positive mounting features on a rail with plain bottom,
//     then connect it up when positioning keyboard in body
//   - separate top and bottom features, since they will end up on two objects (body and base)
//   - perhaps angle the plain bottom by KBD_TOP_A (but top actually can stay straight

// - check docs how is the keycap hole finished (rounded corners/edges?)


// Keyboard: Royal Kludge R65 (RK-R65-R14BKM)

// Model coordinates (operator is looking at the keyboard in X direction)
// Real keyboard sizes, not scaled

// Board dimensions, without dampers and mounting holes
K65_BOARD_X = 98;
K65_BOARD_Y = 308;

// Keyboard bottom to top of the board; at least 9.5; board w/o connectors is 6.5
K65_BOARD_Z = 10;

// Top of the board to bottom of key caps + about 1 mm extra
// = how much above K65_BOARD_Z is inside the body
K65_HIDDEN_Z = 6.5;

// Extra height above K65_HIDDEN_Z, to clear the keyboard top plane; custom
K65_MASK_EXTRA_Z = 10;

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
K65_DAMPER_Y = 40;
K65_DAMPER_Z = 6.5;

// Width of the board including dampers in X (K65_BOARD_X + 2 * damper extra X)
K65_TOTAL_X = 106;

// Dampers are slightly embedded in the board in X, calculate how much
k65_damper_center_to_center_x = K65_TOTAL_X - 2 * K65_DAMPER_X / 2;
k65_damper_attach_x = (K65_BOARD_X - k65_damper_center_to_center_x) / 2;

// Center of damper in Z is attached 0.75 from board top (K65_BOARD_Z)
K65_DAMPER_ATTACH_Z = 0.75;

// Centers of dampers in Y measured from board center, symmetrical except the one near backspace
K65_DAMPER_ATTACH_IN_Y = 43.5;
K65_DAMPER_ATTACH_OUT_Y = 130;
K65_DAMPER_ATTACH_BSPC_Y = 120;

// Shape of the key area
function k65_keys_plane() =
    // Front left corner is in [0, 0] for building the mask, then ymove centers the mask in Y
    ymove(k65_keys_mask_size.y / 2,
        difference([
            rect(k65_keys_mask_size,
                anchor = LEFT + TOP
            ),
            // Cutout next to backspace
            move([
                4 * K65_KEYCAP_SIZE,
                -15 * K65_KEYCAP_SIZE
            ], rect([
                    K65_KEYCAP_SIZE + K65_KEYCAP_MARGIN + DELTA,
                    K65_KEYCAP_SIZE + K65_KEYCAP_MARGIN + DELTA
                ],
                anchor = LEFT + TOP
            )),
            // Cutout next to cursor keys
            move([
                -K65_KEYCAP_MARGIN - DELTA,
                -12.5 * K65_KEYCAP_SIZE
            ], rect([
                    K65_KEYCAP_SIZE + K65_KEYCAP_MARGIN + DELTA,
                    K65_KEYCAP_SIZE / 2
                ],
                anchor = LEFT + TOP
            ))
        ])
    );

// Mask for the keyboard top plane, to make space for the keycaps
module k65_keys_mask() {
    linear_sweep(
        k65_keys_plane(),
        height = K65_HIDDEN_Z + K65_MASK_EXTRA_Z
    );
}

// Damper used to mount the keyboard
module k65_damper() {
    cuboid(
        [K65_DAMPER_X, K65_DAMPER_Y, K65_DAMPER_Z],
        edges = [FWD + LEFT, FWD + RIGHT, BACK + LEFT, BACK + RIGHT],
        rounding = K65_DAMPER_X / 2
    );
}

// k65_damper();

// Mask to cut out space for the keyboard inside the body
module k65_board_mask() {
    // Space for the board
    cuboid(
        [K65_BOARD_X, K65_BOARD_Y, K65_BOARD_Z],
        anchor = LEFT + BOTTOM
    );

    // Inside dampers
    xflip_copy(x = K65_BOARD_X / 2) // front -> back
        yflip_copy() { // left -> right
            move([
                k65_damper_attach_x,
                K65_DAMPER_ATTACH_IN_Y,
                K65_BOARD_Z - K65_DAMPER_ATTACH_Z
            ])
                k65_damper();
        }

    // Outside front dampers
    yflip_copy() { // left -> right
        move([
            k65_damper_attach_x,
            K65_DAMPER_ATTACH_OUT_Y,
            K65_BOARD_Z - K65_DAMPER_ATTACH_Z
        ])
            k65_damper();
    }

    // Outside back left damper
    move([
        K65_BOARD_X - k65_damper_attach_x,
        K65_DAMPER_ATTACH_OUT_Y,
        K65_BOARD_Z - K65_DAMPER_ATTACH_Z
    ])
        k65_damper();

    // Outside back right damper, this one is not symmetrical
    move([
        K65_BOARD_X - k65_damper_attach_x,
        -K65_DAMPER_ATTACH_BSPC_Y,
        K65_BOARD_Z - K65_DAMPER_ATTACH_Z
    ])
        k65_damper();
}

module k65_mask() {
    k65_board_mask();

    zmove(K65_BOARD_Z - DELTA)
        k65_keys_mask();
}

k65_mask();
