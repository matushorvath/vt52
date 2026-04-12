include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

// "Cassette cover", dark cover on the right side of the screen

// TODO
// locating features on cover
// mounting tabs on cover
// angle bottom edge of the cover
// make sure the angles and radiuses are transformed same way as with the screen

// // Depth of the cover above screen plane
// CC_VISIBLE_DEPTH = 2;

// // Space left and right of the handle
// CC_HANDLE_MARGIN_Z = 4;

// // Top of the cover to bottom of the handle
// CC_HANDLE_POS = 205;

// // Actual visible handle depth, without depth of the cover
// cc_handle_depth = CC_HANDLE_TOTAL_DEPTH - 4; // estimated cover depth, 4 = CC_VISIBLE_DEPTH(=2) + 2

// CC_HANDLE_HEIGHT = 2; // estimated

// // This does not match CC_WIDTH_Z, the difference is 6.5 mm, that's why we don't use CC_WIDTH_Z
// CC_HOLE_LEFT_Z = 63;
// CC_HOLE_RIGHT_Z = 222.5;
// cc_hole_center_z = (CC_LEFT_Z + CC_RIGHT_Z) / 2;
// cc_hole_width = CC_HOLE_RIGHT_Z - CC_HOLE_LEFT_Z;


// Cover plane, same height as forward screen plane + margin except at the bottom
function cc_plane() =
    let(
        shape = [
            [0, 0],                                                                 // bottom left
            [0, CC_B_R],                                                            // left notch inner corner
            [0 - CC_COVER_MARGIN, CC_B_R],                                          // left notch outer corner
            [0 - CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],                // top left
            [cc_hole_width + CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],    // top right
            [cc_hole_width + CC_COVER_MARGIN, CC_B_R],                              // right notch outer corner
            [cc_hole_width, CC_B_R],                                                // right notch inner corner
            [cc_hole_width, 0],                                                     // bottom right
        ],

        radii = [CC_B_R, 0, 0, CC_TL_R, CC_TR_R, 0, 0, CC_B_R]
    )
    round_corners(shape, radius = radii);

%polygon(cc_plane());

// Cover hole, same height as forward screen plane, except bottom is cut off
function cc_hole() =
    let(
        shape = [
            [0, 0 + CC_B_R],                                                        // bottom left
            [0, scr_fwd_height],                                                    // top left
            [cc_hole_width, scr_fwd_height],                                        // top right
            [cc_hole_width, 0 + CC_B_R],                                            // bottom right
        ],

        radii = [0, CC_TL_R, CC_TR_R, 0]
    )
    round_corners(shape, radius = radii);

polygon(cc_hole());
