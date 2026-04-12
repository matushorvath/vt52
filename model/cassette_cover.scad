include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

// "Cassette cover", dark cover on the right side of the screen

// TODO
// locating features on cover
// mounting tabs on cover
// fix cover bottom corners, see below in cc_cover90
// build cover as a separate object, also body, also whole terminal for the render, with colors

// create a mask to cut out the kbd/scr fillet with R = CC_B_R = 5 and correct bottom angle KBD_TOP_A
// TODO we can then make the hole all the way to the bottom and have cover rest on the kbd surface extension,
// that's how they did it, I can see now, no need to cut off the bottom of cover mask

// Space left and right of the handle
// CC_HANDLE_MARGIN_Z = 4;

// Top of the cover to bottom of the handle
// CC_HANDLE_POS = 205;

// Actual visible handle depth, without depth of the cover
// cc_handle_depth = CC_HANDLE_TOTAL_DEPTH - 4;

// CC_HANDLE_HEIGHT = 2;


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

// polygon(cc_cover_plane());

// cc_cover();

// Cover hole, same height as forward screen plane
function cc_hole_plane(dist) =
    // Generate plane for given distance from the screen plane
    let(
        extra_top = sign(dist) * ang_adj_to_opp(SCR_FWD_A, abs(dist)),
        extra_bot = sign(dist) * ang_adj_to_opp(KBD_TOP_A + SCR_FWD_A, abs(dist)),

        shape = [
            [0, -extra_bot],                                    // bottom left
            [0, scr_fwd_height - extra_top],                    // top left
            [cc_hole_width, scr_fwd_height - extra_top],        // top right
            [cc_hole_width, -extra_bot],                        // bottom right
        ],

        radii = [CC_B_R, CC_TL_R, CC_TR_R, CC_B_R]
    )
    round_corners(shape, radius = radii);

module cc_hole() {
    // Position the extra face
    extra_face = apply(
        // Transformations are applied last to first
        IDENT // scr_extra_dist_x
            * move([kbd_back_x, kbd_back_y, CC_HOLE_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * xmove(-scr_extra_dist_x) // place in front of the screen plane
            * yrot(-90), // orient relative to the model
        path3d(cc_hole_plane(scr_extra_dist_x))
    );
    //stroke(extra_face, closed=true);

    // Position the forward face
    fwd_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([kbd_back_x, kbd_back_y, CC_HOLE_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * yrot(-90), // orient relative to the model
        path3d(cc_hole_plane(0))
    );
    //stroke(fwd_face, closed=true);

    // Position the back face
    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([kbd_back_x, kbd_back_y, CC_HOLE_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * xmove(BODY_WALL * 2) // make sure to clear the wall at an angle
            * yrot(-90), // orient relative to the model
        path3d(cc_hole_plane(-BODY_WALL * 2))
    );
    //stroke(back_face, closed=true);

    faces = [extra_face, fwd_face, back_face];
    skin(faces, slices = 10);
}

// %polygon(cc_hole_plane(10));
// polygon(cc_hole_plane(0));

// cc_hole();

include <body.scad>

xrot(90) {
//    cc_cover();

    difference() {
        body(true);
        cc_hole();
    }
}
