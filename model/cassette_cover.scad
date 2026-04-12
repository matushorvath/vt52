// use
include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

// TODO
// locating features on cover
// mounting tabs on cover
// build cover as a separate object, also body as separate object, also whole terminal for the render, with colors

// Space left and right of the handle
// CC_HANDLE_MARGIN_Z = 4;

// Top of the cover to bottom of the handle
// CC_HANDLE_POS = 205;

// Actual visible handle depth, without depth of the cover
// cc_handle_depth = CC_HANDLE_TOTAL_DEPTH - 4;

// CC_HANDLE_HEIGHT = 2;


// Cover plane, same height as forward screen plane + margin except at the bottom
function cc_cover_plane(dist) =
    // Generate plane for given distance from the screen plane
    let(
        extra_bot = sign(dist) * ang_adj_to_opp(KBD_TOP_A + SCR_FWD_A, abs(dist)),

        shape = [
            [0, 0 - extra_bot],                                                     // bottom left
            [0, CC_B_R - extra_bot],                                                // left notch end of rounding
            [0, KBD_BACK_R],                                                        // left notch inner corner
            [0 - CC_COVER_MARGIN, KBD_BACK_R],                                      // left notch outer corner
            [0 - CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],                // top left
            [cc_mask_width + CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],    // top right
            [cc_mask_width + CC_COVER_MARGIN, KBD_BACK_R],                          // right notch outer corner
            [cc_mask_width, KBD_BACK_R],                                            // right notch inner corner
            [cc_mask_width, CC_B_R - extra_bot],                                    // right notch end of rounding
            [cc_mask_width, 0 - extra_bot],                                         // bottom right
        ],

        radii = [CC_B_R, 0, 0, 0, CC_TL_R, CC_TR_R, 0, 0, 0, CC_B_R]
    )
    round_corners(shape, radius = radii);

module cc_cover() {
    // Position the forward face
    fwd_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * xmove(-CC_VISIBLE_DEPTH) // cover depth
            * yrot(-90), // orient relative to the model
        path3d(cc_cover_plane(CC_VISIBLE_DEPTH))
    );
    // stroke(fwd_face, closed=true);

    // Position the back face
    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * yrot(-90), // orient relative to the model
        path3d(cc_cover_plane(0))
    );
    // stroke(back_face, closed=true);

    faces = [fwd_face, back_face];
    skin(faces, slices = 10);
}

// %polygon(cc_cover_plane(CC_VISIBLE_DEPTH));
// polygon(cc_cover_plane(0));

// cc_cover();

// include <body.scad>
// xrot(90) {
//     cc_cover();
//     %body(true);
// }
