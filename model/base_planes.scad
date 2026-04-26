// use
include <common.scad>
include <base_dimensions.scad>
include <BOSL2/std.scad>

// TODO mask parameter for the mask
function base_ee_ff_half_plane(width_z, height_y, angle) =
    // Unlike some other _plane functions, this uses model coordinates (horizontal Z and vertical Y)
    let(
        // Bottom coordinate is raised to align the top edge
        bottom_y = BASE_Y - height_y,

        // Bottom left corner if there was no rounding
        bottom_z = width_z - ang_adj_to_opp(angle, height_y),

        shape = [
            [0, bottom_y],
            [0, BASE_Y],
            [width_z, BASE_Y],
            [bottom_z, bottom_y]
        ],

        radii = [
            0, 0, 0, BASE_R
        ],

        // Make number of segments in the rounded corners the same, it looks better after skin()
        // The rounded corner is a (90 - angle) circle section, let's scale $fn based on that
        // (the number of segments for a 90 degree corner will instead fit into a (90 - angle) corner)
        corner_fn = fn_where_needed * 90 / (90 - angle)
    )
    round_corners(shape, radius = radii, $fn = corner_fn);

polygon(base_ee_ff_half_plane(260, base_ee_y, BASE_EE_A)); // TODO use real curve instead of 260

ymove(100)
    polygon(base_ee_ff_half_plane(260, (base_ee_y + base_ff_y) / 2 , (BASE_EE_A + BASE_FF_A) / 2)); // TODO use real curve instead of 260

ymove(200)
    polygon(base_ee_ff_half_plane(260, base_ff_y, BASE_FF_A)); // TODO use real curve instead of 260
