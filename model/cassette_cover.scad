include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

// "Cassette cover", dark cover on the right side of the screen

// TODO
// locating features on cover
// mounting tabs on cover
// fix cover bottom corners, see below in cc_cover90
// build cover as a separate object

// create a mask to cut out the kbd/scr fillet with R = CC_B_R = 5 and correct bottom angle KBD_TOP_A
// TODO we can then make the hole all the way to the bottom and have cover rest on the kbd surface extension,
// that's how they did it, I can see now, no need to cut off the bottom of cover mask

// // Depth of the cover above screen plane
// CC_VISIBLE_DEPTH = 2;

// // Space left and right of the handle
// CC_HANDLE_MARGIN_Z = 4;

// // Top of the cover to bottom of the handle
// CC_HANDLE_POS = 205;

// // Actual visible handle depth, without depth of the cover
// cc_handle_depth = CC_HANDLE_TOTAL_DEPTH - 4; // estimated cover depth, 4 = CC_VISIBLE_DEPTH(=2) + 2

// CC_HANDLE_HEIGHT = 2; // estimated


// Cover plane, same height as forward screen plane + margin except at the bottom
function cc_cover_plane() =
    let(
        // Extend the bottom edge down to make up for KBD_TOP_A and SCR_FWD_A
        // We than mask off the back side of that extension in cc_cover()
        extend_bottom = ang_adj_to_opp(KBD_TOP_A + SCR_FWD_A, CC_VISIBLE_DEPTH),

        shape = [
            [0, 0 - extend_bottom],                                                 // bottom left
            [0, CC_B_R - extend_bottom],                                            // left notch inner corner
            [0 - CC_COVER_MARGIN, CC_B_R - extend_bottom],                          // left notch outer corner
            [0 - CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],                // top left
            [cc_hole_width + CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],    // top right
            [cc_hole_width + CC_COVER_MARGIN, CC_B_R - extend_bottom],              // right notch outer corner
            [cc_hole_width, CC_B_R - extend_bottom],                                // right notch inner corner
            [cc_hole_width, 0 - extend_bottom],                                     // bottom right
        ],

        radii = [CC_B_R, 0, 0, CC_TL_R, CC_TR_R, 0, 0, CC_B_R]
    )
    round_corners(shape, radius = radii);

// Cover hole, same height as forward screen plane, except bottom is cut off
function cc_hole_plane() =
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

// %polygon(cc_cover_plane());
// polygon(cc_hole_plane());

module cc_cover() {
    edge_mask_y = 5; // any sufficiently large number to clear the object

    difference() {
        // Cover object
        linear_sweep(
            cc_cover_plane(),
            height = CC_VISIBLE_DEPTH
        );

        // Cut off bottom edge to match KBD_TOP_A + SCR_FWD_A
        // TODO this isn't good enough, bottom corners will still interfere with kbd/scr fillet
        // we also need to cut of the back side of the radiuses at an angle
        // the correct way is to do a skin() with two planes, copy it from screen.scad
        // and the same thing will be needed for the hole
        move([-DELTA, 0, -DELTA])
            prismoid(
                size2 = [cc_hole_width + 2 * DELTA, edge_mask_y],
                xang = [90, 90],
                yang = [90, 90 - KBD_TOP_A - SCR_FWD_A],
                h = CC_VISIBLE_DEPTH + 2 * DELTA,
                anchor = LEFT + BACK + DOWN
            );
    }
}

//cc_cover();

module cc_move() {
    // For the cover, margins (CC_COVER_MARGIN) are in negative coordinates, be careful
    // That allows use to use the same positioning for the hole and for the cover

    // Move bottom back edge of the cover to match keyboard back
    move([kbd_back_x, kbd_back_y, CC_HOLE_LEFT_Z])
    //move([0, 13.5, CC_HOLE_LEFT_Z])
        // Rotate to match screen face angle
        zrot(-SCR_FWD_A)
            // Orient correctly relative to the model
            rot([0, -90, 0])
                children();
}

// include <body.scad>

// xrot(90) {
//     cc_move()
//         cc_cover();

//     %body(true);
// }
