include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

// We need to use $fn for the bezels, not $fa, in order to guarantee same amount
// of vertices in corners with different radiuses

function screen_fwd_plane(mask) =
    let(
        owall = mask ? 0 : BODY_WALL,

        shape = [
            [0 - owall, 0 - owall],                             // bottom left
            [0 - owall, scr_fwd_height + owall],                // top left
            [scr_fwd_width + owall, scr_fwd_height + owall],    // top right
            [scr_fwd_width + owall, 0 - owall],                 // bottom right
        ],

        radii = [
            SCR_FWD_BL_R + owall,
            SCR_FWD_TL_R + owall,
            SCR_FWD_TR_R + owall,
            SCR_FWD_BR_R + owall,
        ]
    )
    round_corners(shape, radius = radii, $fn = fn_where_needed);

// Extra plane is only used when mask = true
function screen_extra_plane(mask) =
    let(
        owall = mask ? 0 : BODY_WALL,

        shape = [
            [0 - owall, 0 - owall],                                 // bottom left
            [0 - owall, scr_extra_height + owall],                  // top left
            [scr_extra_width + owall, scr_extra_height + owall],    // top right
            [scr_extra_width + owall, 0 - owall],                   // bottom right
        ],

        // TODO corner radius should also be adjusted to form a continuous curve
        radii = [
            SCR_FWD_BL_R + owall,
            SCR_FWD_TL_R + owall,
            SCR_FWD_TR_R + owall,
            SCR_FWD_BR_R + owall,
        ]
    )
    round_corners(shape, radius = radii, $fn = fn_where_needed);

function screen_back_plane(mask) =
    let(
        owall = mask ? 0 : BODY_WALL,

        shape = [
            [0 - owall, 0 - owall],                             // bottom left
            [0 - owall, SCR_BACK_HEIGHT + owall],               // top left
            [SCR_BACK_WIDTH + owall, SCR_BACK_HEIGHT + owall],  // top right
            [SCR_BACK_WIDTH + owall, 0 - owall],                // bottom right
        ],

        radii = [
            SCR_BACK_CORNER_A + owall,
            SCR_BACK_CORNER_A + owall,
            SCR_BACK_CORNER_A + owall,
            SCR_BACK_CORNER_A + owall,
        ]
    )
    round_corners(shape, radius = radii, $fn = fn_where_needed);

// %polygon(screen_fwd_plane(true));
// polygon(screen_fwd_plane(false));

// %polygon(screen_extra_plane(true));
// polygon(screen_extra_plane(false));

// %polygon(screen_back_plane(true));
// polygon(screen_back_plane(false));
