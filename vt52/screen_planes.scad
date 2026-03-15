include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

function screen_front_plane() =
    let(
        scr_height = SCR_FRONT_TOP_Y - scr_front_bottom_y,
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
    // $fn must match between screen_front_plane and screen_back_plane (set in common.scad)
    // otherwise skin() will produce artifacts
    round_corners(shape, radius=radii);

function screen_back_plane() =
    let(
        shape = [
            [0, 0],                             // bottom left
            [0, SCR_BACK_HEIGHT],               // top left
            [SCR_BACK_WIDTH, SCR_BACK_HEIGHT],  // top right
            [SCR_BACK_WIDTH, 0],                // bottom right
        ],

        radii = [
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
            SCR_BACK_CORNER_A,
        ]
    )
    // TODO add a rounded CRT screen effect to the sides, but number of vertices must match screen_front_plane
    // $fn must match between screen_front_plane and screen_back_plane (set in common.scad)
    // otherwise skin() will produce artifacts
    round_corners(shape, radius=radii);

//polygon(screen_front_plane());
//polygon(screen_back_plane());
