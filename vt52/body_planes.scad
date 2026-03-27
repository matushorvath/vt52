include <common.scad>
include <body_dimensions.scad>
include <BOSL2/std.scad>

PREVIEW_TABLE_SKIP = 20;

// How much is inner corner offset from the outer corner
// given wall thickness and two edge angles measured from vertical and horizontal axis
function offset_corner(owall, fwd_a, top_a) =
    let(
        d = fwd_a + top_a,
        k = tan(d) - 1/cos(d)
    )
    [
        owall * (cos(fwd_a) + k * sin(fwd_a)),
        owall * (sin(fwd_a) - k * cos(fwd_a))
    ];

function body_xy_plane(outside) =
    let(
        // If inside, leave a wall around, and add a DELTA where there is no wall
        owall = outside ? 0 : BODY_WALL,
        oclear = outside ? 0 : DELTA,

        ofwd_bot_x = owall / cos(KBD_FWD_A),
        ofwd_top = offset_corner(owall, KBD_FWD_A, KBD_TOP_A),

        shape = [
            [0 + ofwd_bot_x, 0 - oclear],                            // keyboard forward bottom
            [kbd_fwd_x + ofwd_top.x, KBD_FWD_Y - ofwd_top.y],        // keyboard forward top
            [kbd_back_x + owall, kbd_back_y - owall],                // keyboard back top
            [SCR_TOP_X + owall, SCR_TOP_Y - owall],                  // body forward top
            [BODY_BACK_X + oclear, SCR_TOP_Y - owall],               // body back top
            [BODY_BACK_X + oclear, 0 - oclear]                       // body back bottom
        ],

        radii = [
            0, 0, KBD_BACK_R + owall, 0, 0, 0
        ]
    )
    round_corners(shape, radius = radii);

// TODO parameters should just be outside, side_curve - the curve has everything else
// height_y is always SCR_TOP_Y, corner_r is always YZ_TOP_CORNER_R
function body_yz_half_plane(outside, top_half_x, bottom_half_x, height_y, corner_r, side_curve) =
    let(
        // If inside, leave a wall around, and add a DELTA where there is no wall
        owall = outside ? 0 : BODY_WALL,
        oclear = outside ? 0 : DELTA,

        // Skip most points if we are in preview mode
        optimized_side_curve =
            $preview ?
            [for (i = [0 : PREVIEW_TABLE_SKIP : len(side_curve) - 1]) side_curve[i]] :
            side_curve,

        shape = [
            [0, 0 - oclear],                                        // center bottom
            [0, height_y - owall],                                  // center top
            [top_half_x - owall, height_y - owall],                 // side top
            for (p = optimized_side_curve)
                if (p.x <= SCR_TOP_Y - corner_r)
                    [p.y - owall, p.x],   // side top to side bottom curve; wall is approximate
            [bottom_half_x - owall, 0 - oclear]
        ],
        radii = [
            0, 0, corner_r - owall,
            for (i = [4 : len(shape)]) 0
        ]
    )
    round_corners(shape, radius = radii);

// %polygon(body_xy_plane(true));
// polygon(body_xy_plane(false));

// %polygon(body_yz_half_plane(true, YZ_CURVE_X000[0][1], YZ_BOTTOM_HALF[0], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X000));
// polygon(body_yz_half_plane(false, YZ_CURVE_X000[0][1], YZ_BOTTOM_HALF[0], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X000));
// polygon(body_yz_half_plane(true, YZ_CURVE_X050[0][1], YZ_BOTTOM_HALF[1], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X050));
// polygon(body_yz_half_plane(true, YZ_CURVE_X100[0][1], YZ_BOTTOM_HALF[2], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X100));
// polygon(body_yz_half_plane(true, YZ_CURVE_X150[0][1], YZ_BOTTOM_HALF[3], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X150));
// polygon(body_yz_half_plane(true, YZ_CURVE_X200[0][1], YZ_BOTTOM_HALF[4], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X200));
// polygon(body_yz_half_plane(true, YZ_CURVE_X250[0][1], YZ_BOTTOM_HALF[5], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X250));
// polygon(body_yz_half_plane(true, YZ_CURVE_X300[0][1], YZ_BOTTOM_HALF[6], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X300));
// polygon(body_yz_half_plane(true, YZ_CURVE_X350[0][1], YZ_BOTTOM_HALF[7], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X350));
// polygon(body_yz_half_plane(true, YZ_CURVE_X400[0][1], YZ_BOTTOM_HALF[8], SCR_TOP_Y, YZ_TOP_CORNER_R, YZ_CURVE_X400));
