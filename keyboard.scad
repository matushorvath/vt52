include <common.scad>
include <BOSL2/std.scad>

// keyboard: Royal Kludge R65 (RK-R65-R14BKM)

// one key width: 19 mm

// TODO
// - top mask for the keys
//   - LEDs
//   - space top right
//   - space left of arrow keys
// - body of the keyboard
//   - dampers
//   - holes
//   - space for components on board reverse
// - angle the masks
// - design mounting hardware
//   - pins for the holes, they will be fragile, stiffen them
//   - rests for the dampers
//   - perhaps brackets for the corners? but not too close
// - locate the keyboard in body
//   - add X space for the keyboard
// - find if bottom needs to be adjusted to fit

// - klavesnica rozmery
//   - 14.2 mm odspodu dosky po spodnu hranu klaves
//   - 23 mm (dole) - 25.5 mm (hore) odspodu dosky po vrch klaves
//   - spodna strana tlmicov je 9.5 mm od spodnej strany klaves
//     - inak povedane, klavesnica ma byt uchytena hore a dole 9.5 mm pod spodnou hranicou klaves
//     - pod tym uchytom este bude treba cca 5mm miesta na dosku
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



// Model coordinates (operator is looking at the keyboard in X direction)

// Board dimensions, without dampers and mounting holes
K65_X = 98;
K65_Y = 308;

// Keyboad bottom to top of the board; at least 9.5; board w/o connectors is 6.5
K65_BOARD_Z = 10;

// One keycap size (including space between keys)
K65_KEYCAP_SIZE = 19;
// Extra margin around the keycap area
K65_KEYCAP_MARGIN = 2;

// Keyboard bottom to bottom of key caps + about 1 mm extra; how much of the keyboard is inside the body
//K65_HIDDEN_Z = 13 + 3.5;

// Height of the keys mas, to cut through the keyboard top plane; custom
K65_KEYS_MASK_Z = 10;

//K65_DAMPER_X = 0.4; // one damper X

// TODO check docs how is the keycap hole finished (rounded corners/edges?)

// Shape of the key area
function keys_plane() =
    difference([
        rect([
                5 * K65_KEYCAP_SIZE + K65_KEYCAP_MARGIN,
                16 * K65_KEYCAP_SIZE + K65_KEYCAP_MARGIN
            ],
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
module keys_mask() {
    linear_sweep(
        keys_plane(),
        height = K65_KEYS_MASK_Z // TODO
    );
}

// keys_mask();

// Mask to cut out space for the keyboard inside the body
module keyboard_mask() {
    // Space for the board
    cuboid(
        [K65_X, K65_Y, K65_BOARD_Z],
        anchor = LEFT + BACK + BOTTOM
    );
}

// keyboard_mask();
