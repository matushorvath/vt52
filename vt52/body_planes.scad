include <common.scad>
include <body_dimensions.scad>
include <BOSL2/std.scad>

function body_xy_plane() =
    let(
        shape = [
            [0, 0],                             // keyboard forward bottom
            [kbd_fwd_x, KBD_FWD_Y],             // keyboard forward top
            [kbd_back_x, kbd_back_y],           // keyboard back top
            [SCR_TOP_X, BODY_Y],                // body forward top
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
                    [p[1], p[0]],   // side top to side bottom curve
            [bottom_half_x, 0]
        ],
        radii = [
            0, 0, corner_r,
            for (i = [4 : len(shape)]) 0
        ]
    )
    round_corners(shape, radius=radii);

// polygon(body_xy_plane());
// polygon(body_yz_half_plane(YZ_CURVE_X000[0][1], YZ_BOTTOM_HALF[0], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X000));
// polygon(body_yz_half_plane(YZ_CURVE_X050[0][1], YZ_BOTTOM_HALF[1], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X050));
// polygon(body_yz_half_plane(YZ_CURVE_X100[0][1], YZ_BOTTOM_HALF[2], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X100));
// polygon(body_yz_half_plane(YZ_CURVE_X150[0][1], YZ_BOTTOM_HALF[3], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X150));
// polygon(body_yz_half_plane(YZ_CURVE_X200[0][1], YZ_BOTTOM_HALF[4], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X200));
// polygon(body_yz_half_plane(YZ_CURVE_X250[0][1], YZ_BOTTOM_HALF[5], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X250));
// polygon(body_yz_half_plane(YZ_CURVE_X300[0][1], YZ_BOTTOM_HALF[6], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X300));
// polygon(body_yz_half_plane(YZ_CURVE_X350[0][1], YZ_BOTTOM_HALF[7], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X350));
// polygon(body_yz_half_plane(YZ_CURVE_X400[0][1], YZ_BOTTOM_HALF[8], BODY_Y, YZ_TOP_CORNER_R, YZ_CURVE_X400));
