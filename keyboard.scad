include <common.scad>
include <BOSL2/std.scad>


// TODO
// - body of the keyboard
//   - dampers
//   - holes
// - angle the masks
// - design mounting hardware
//   - pins for the holes, they will be fragile, stiffen them
//   - rests for the dampers
//   - perhaps brackets for the corners? but not too close
// - locate the keyboard in body
//   - add X space for the keyboard
// - find if bottom needs to be adjusted to fit

// - try to use the soft foam and silicon that was below the keyboard
// - don't forget about the USB board
//   - USB board connects between left shift and Z

// TODO
// - add mask for the mounting features on board
//   - can be approximate
// - add positive mounting features
//   - but also, how mounting features will attach to the body depends on keyboard position
//   - perhaps add the positive mounting features on a rail with plain bottom,
//     then connect it up when positioning keyboard in body
//   - separate top and bottom features, since they will end up on two objects (body and base)
//   - perhaps angle the plain bottom by KBD_TOP_A (but top actually can stay straight

// TODO check docs how is the keycap hole finished (rounded corners/edges?)


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
k65_damper_center_to_center_x = K65_INCL_DAMPERS_X - 2 * K65_DAMPER_X / 2;
k65_damper_attach_x = (K65_BOARD_X - k65_damper_center_to_center_x) / 2;

// Center of damper in Z is attached 0.75 from board top (K65_BOARD_Z)
K65_DAMPER_ATTACH_Z = 0.75;

// Centers of dampers in Y measured from board center, symmetrical except the one near backspace
K65_DAMPER_ATTACH_IN_Y = 43.5;
K65_DAMPER_ATTACH_OUT_Y = 130;
K65_DAMPER_ATTACH_BSPC_Y = 120;

// Shape of the key area
function k65_keys_plane() =
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
    ]);

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

k65_damper();

// Mask to cut out space for the keyboard inside the body
module k65_board_mask() {
    // Space for the board
    cuboid(
        [K65_BOARD_X, K65_BOARD_Y, K65_BOARD_Z],
        anchor = LEFT + BACK + BOTTOM
    );
}


// // Dampers are slightly embedded in the board in X, calculate how much
// k65_damper_attach_x = (K65_BOARD_X - k65_damper_center_to_center_x) / 2;

// // Center of damper in Z is attached 0.75 from board top (K65_BOARD_Z)
// K65_DAMPER_ATTACH_Z = 0.75;

// // Centers of dampers in Y measured from board center, symmetrical except the one near backspace
// K65_DAMPER_ATTACH_IN_Y = 43.5;
// K65_DAMPER_ATTACH_OUT_Y = 130;
// K65_DAMPER_ATTACH_BSPC_Y = 120;



module k65_mask() {
    k65_board_mask();

    keys_mask_shift = [
        (K65_BOARD_X - k65_keys_mask_size.x) / 2,
        -(K65_BOARD_Y - k65_keys_mask_size.y) / 2,
    ];

    move([keys_mask_shift.x, keys_mask_shift.y, K65_BOARD_Z - DELTA])
        k65_keys_mask();
}

k65_mask();


//   - tlmice:
//     - nielen tlmice vycuhuju hore a dole, po celej sirke by malo byt miesto na veci vycuhujuce z dosky
//     - samotne tlmice vpravo a vlavo su dlhe 12 mm
//     - nezabudnut ze klavesnica ma byt pod uhlom
//     - v originalnom case drzi klavesnica:
//       - 4 piny, jeden na kazdej strane, R2.95, vyska 8mm od spodu dosky (to je vyska po vrch dosky)
//       - vpravo a vlavo nie su piny na stred, su 40 mm od spodu spodnych tlmicov
//       - hore a dole su piny na stred
//       - diery su vzdialene 97.8 mm od seba (predne vs zadne, stred dier)
//         - stred dier je zarovnany s hranami
//       - vpravo a vlavo su diery ovalne, dovoluju pohyb vpravo vlavo
//       - pod tlmicmi su nosniky, co su 3 zvisle rebra, 1 mm hrube (co je asi cost cutting)