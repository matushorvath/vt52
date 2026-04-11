include <common.scad>
include <BOSL2/std.scad>

// keyboard: Royal Kludge R65 (RK-R65-R14BKM)

// one key width: 19 mm

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

// - klavesnica rozmery
//   - medzi left shift a Z je konektor na USB, vpravo od backspace je konektor na volume
//   - tlmice:
//     - 4 hore 4 dole, symetricky
//     - nielen tlmice vycuhuju hore a dole, po celej sirke by malo byt miesto na veci vycuhujuce z dosky
//     - stredy su 4.35mm a 13mm od stredu dosky, sprava dolava
//       - okrem vpravo hore, kde je to 12 mm namiesto 13 mm (je urezany roh dosky pri backspace)
//     - vysoke 6.4 mm (zdola hore)
//     - dlhe 40 mm (sprava dolava)
//     - samotne tlmice vpravo a vlavo su dlhe 12 mm
//     - hlboke 5 mm (spredu dozadu)
//     - nezabudnut ze klavesnica ma byt pod uhlom
//     - v originalnom case drzi klavesnica:
//       - 4 piny, jeden na kazdej strane, R2.95, vyska 8mm od spodu dosky (to je vyska po vrch dosky)
//       - vpravo a vlavo nie su piny na stred, su 40 mm od spodu spodnych tlmicov
//       - hore a dole su piny na stred
//       - diery su vzdialene 97.8 mm od seba (predne vs zadne, stred dier)
//         - stred dier je zarovnany s hranami
//       - vpravo a vlavo su diery ovalne, dovoluju pohyb vpravo vlavo
//       - pod tlmicmi su nosniky, co su 3 zvisle rebra, 1 mm hrube (co je asi cost cutting)

// TODO
// - add mask for the mounting features on board
//   - can be approximate
// - add positive mounting features
//   - but also, how mounting features will attach to the body depends on keyboard position
//   - perhaps add the positive mounting features on a rail with plain bottom,
//     then connect it up when positioning keyboard in body
//   - separate top and bottom features, since they will end up on two objects (body and base)
//   - perhaps angle the plain bottom by KBD_TOP_A (but top actually can stay straight


// Model coordinates (operator is looking at the keyboard in X direction)

// Board dimensions, without dampers and mounting holes
K65_X = 98;
K65_Y = 308;

// Keyboad bottom to top of the board; at least 9.5; board w/o connectors is 6.5
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

//K65_DAMPER_X = 0.4; // one damper X

// TODO check docs how is the keycap hole finished (rounded corners/edges?)

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

// Mask to cut out space for the keyboard inside the body
module k65_board_mask() {
    // Space for the board
    cuboid(
        [K65_X, K65_Y, K65_BOARD_Z],
        anchor = LEFT + BACK + BOTTOM
    );
}

module k65_mask() {
    k65_board_mask();

    keys_mask_shift = [
        (K65_X - k65_keys_mask_size.x) / 2,
        -(K65_Y - k65_keys_mask_size.y) / 2,
    ];

    move([keys_mask_shift.x, keys_mask_shift.y, K65_BOARD_Z - DELTA])
        k65_keys_mask();
}

k65_mask();
