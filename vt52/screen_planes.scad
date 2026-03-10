include <common.scad>
include <screen_dimensions.scad>

function screen_front_plane() =
    let(
        scr_height = SCR_FRONT_TOP_Y - kbd_back_y,
        scr_width = SCR_FRONT_LEFT_Z - SCR_FRONT_RIGHT_Z,

        shape = [
            [0, 0],                     // bottom left
            [0, scr_height],            // top left
            [scr_width, scr_height],    // top right
            [scr_width, 0],             // bottom right
        ],

        radii = [
            SCR_FRONT_BL_R,
            SCR_FRONT_TL_R,
            SCR_FRONT_TR_R,
            SCR_FRONT_BR_R,
        ]
    )
    round_corners(shape, radius=radii);

// TODO proper screen shape based on real screen
// given are: width and height of the screen, angles of the bezel, angle of the screen
// based on that we should calculate how deep the screen will be in the bezel
// in the real terminal this is controlled by SCR_BACK_SCREEN_X, SCR_BACK_SCREEN_Y
function screen_back_plane() =
    let(
        scr_height = SCR_FRONT_TOP_Y - kbd_back_y,
        scr_width = SCR_FRONT_LEFT_Z - SCR_FRONT_RIGHT_Z,

        shape = [
            [0, 0],                     // bottom left
            [0, scr_height],            // top left
            [scr_width, scr_height],    // top right
            [scr_width, 0],             // bottom right
        ],

        radii = [
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
        ]
    )
    round_corners(shape, radius=radii);

//polygon(screen_front_plane());
polygon(screen_back_plane());
