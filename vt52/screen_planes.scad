include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

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
    // $fn must match between screen_front_plane and screen_back_plane
    // otherwise skin() will produce artifacts
    round_corners(shape, radius=radii, $fn=200);

function screen_back_plane() =
    let(
        // Make the bezel slightly smaller than the panel
        width = SCR_PANEL_X - 2 * SCR_PANEL_MARGIN,
        height = SCR_PANEL_Y - 2 * SCR_PANEL_MARGIN,

        shape = [
            [0, 0],                     // bottom left
            [0, height],                // top left
            [width, height],            // top right
            [width, 0],                 // bottom right
        ],

        radii = [
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
        ]
    )
    // TODO add a rounded CRT screen effect to the sides, but number of vertices must match screen_front_plane
    // $fn must match between screen_front_plane and screen_back_plane
    // otherwise skin() will produce artifacts
    round_corners(shape, radius=radii, $fn=200);

//polygon(screen_front_plane());
//polygon(screen_back_plane());
