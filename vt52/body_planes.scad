include <common.scad>
include <body_dimensions.scad>
include <body_tables.scad>
include <BOSL2/std.scad>

function body_xy_plane() =
    let(
        shape = [
            [0, 0],                             // keyboard front bottom
            [kbd_front_x, KBD_FRONT_Y],         // keyboard front top
            [kbd_back_x, kbd_back_y],           // keyboard back top
            [SCR_TOP_X, BODY_Y],                // body front top
            [BODY_BACK_X, BODY_Y],              // body back top
            [BODY_BACK_X, 0]                    // body back bottom
        ],

        radii = [
            0, 0, KBD_BACK_R, 0, 0, 0
        ]
    )
    round_corners(shape, radius=radii);

function body_yz_half_plane(top_half_x, bottom_half_x, height_y, corner_r, side_curve) =
    // TODO make the side rounded, not straight
    let(
        // Approximate shape without the rounded side
        shape = [
            [0, 0],                                                     // center bottom
            [0, height_y],                                              // center top
            [top_half_x, height_y],                                     // side top
            for (p = side_curve)
                if (p[0] <= BODY_Y - corner_r)
                    [p[1], p[0]]    // side top to side bottom curve
        ],
        radii = [
            0, 0, corner_r,
            for (i = [4 : len(shape)]) 0
        ]
    )
    round_corners(shape, radius=radii);

//polygon(body_xy_plane());
//polygon(body_yz_half_plane(YZ_TOP_HALF[0], YZ_BOTTOM_HALF[0], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X000));
