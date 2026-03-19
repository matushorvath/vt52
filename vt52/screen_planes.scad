include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

function screen_fwd_plane() =
    let(
        shape = [
            [0, 0],                             // bottom left
            [0, scr_fwd_height],                // top left
            [scr_fwd_width, scr_fwd_height],    // top right
            [scr_fwd_width, 0],                 // bottom right
        ],

        radii = [
            SCR_FWD_BL_R,
            SCR_FWD_TL_R,
            SCR_FWD_TR_R,
            SCR_FWD_BR_R,
        ]
    )
    // $fn must match between screen_fwd_plane and screen_back_plane (set in common.scad)
    // otherwise skin() will produce artifacts
    round_corners(shape, radius=radii);

function screen_extra_plane() =
    let(
        shape = [
            [0, 0],                                 // bottom left
            [0, scr_extra_height],                  // top left
            [scr_extra_width, scr_extra_height],    // top right
            [scr_extra_width, 0],                   // bottom right
        ],

        // TODO corner radius should also be adjusted to form a continuous curve
        radii = [
            SCR_FWD_BL_R,
            SCR_FWD_TL_R,
            SCR_FWD_TR_R,
            SCR_FWD_BR_R,
        ]
    )
    // $fn must match between screen_fwd_plane and screen_back_plane (set in common.scad)
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
    // $fn must match between screen_fwd_plane and screen_back_plane (set in common.scad)
    // otherwise skin() will produce artifacts
    round_corners(shape, radius=radii);

//polygon(screen_fwd_plane());
//polygon(screen_extra_plane());
//polygon(screen_back_plane());
