// use
include <common.scad>
include <base_dimensions.scad>
include <body_dimensions.scad>
include <data_lists.scad>
include <BOSL2/std.scad>

function base_ee_ff_half_plane(mask, width_z, height_y, angle) =
    // Unlike some other _plane functions, this uses model coordinates (horizontal Z and vertical Y)
    let(
        // If mask, leave a wall around, and add a DELTA where there is no wall
        owall = mask ? BODY_WALL : 0,
        oclear = mask ? DELTA : 0,

        // Bottom coordinate is raised to align the top edge
        bottom_y = BASE_Y - height_y,

        // Bottom left corner if there was no rounding
        bottom_z = width_z - ang_adj_to_opp(angle, height_y),

        shape = [
            [0, bottom_y + owall],                  // center bottom
            [0, BASE_Y + oclear],                   // center top
            [width_z - owall, BASE_Y + oclear],     // side top
            [bottom_z - owall, bottom_y + owall]    // side bottom
        ],

        radii = [
            0, 0, 0, BASE_R - owall
        ],

        // Make number of segments in the rounded corners the same, it looks better after skin()
        // Scale fa_value from 90 degrees to (90 - angle) degrees to achieve that
        // There will still be artifacts for small values of fa
        corner_fa = fa_value * (90 - angle) / 90
    )
    round_corners(shape, radius = radii, $fa = corner_fa);

polygon(base_ee_ff_half_plane(true, lookup(BASE_EE_X, XZ_CURVE_Y000), base_ee_y, BASE_EE_A));
%polygon(base_ee_ff_half_plane(false, lookup(BASE_EE_X, XZ_CURVE_Y000), base_ee_y, BASE_EE_A));

ymove(100) {
    polygon(base_ee_ff_half_plane(true, lookup((BASE_EE_X + BASE_FF_X) / 2, XZ_CURVE_Y000),
        (base_ee_y + base_ff_y) / 2 , (BASE_EE_A + BASE_FF_A) / 2));
    %polygon(base_ee_ff_half_plane(false, lookup((BASE_EE_X + BASE_FF_X) / 2, XZ_CURVE_Y000),
        (base_ee_y + base_ff_y) / 2 , (BASE_EE_A + BASE_FF_A) / 2));
}

ymove(200) {
    polygon(base_ee_ff_half_plane(true, lookup(BASE_FF_X, XZ_CURVE_Y000), base_ff_y, BASE_FF_A));
    %polygon(base_ee_ff_half_plane(false, lookup(BASE_FF_X, XZ_CURVE_Y000), base_ff_y, BASE_FF_A));
}
