include <common.scad>
include <keyboard_dimensions.scad>
include <BOSL2/std.scad>

// TODO
// - holes for mounting pins
// - check docs how is the keycap hole finished (rounded corners/edges?)

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
