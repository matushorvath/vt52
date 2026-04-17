// use
include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

// TODO locating features on cover
// TODO mounting tabs on cover
// TODO handle

// TODO remove
// Space left and right of the handle; estimated from photos
// CC_HANDLE_MARGIN_Z = 1;
// Top of the cover to bottom of the handle
// CC_HANDLE_POS = 205;
// Actual visible handle depth, without depth of the cover
// cc_handle_depth = CC_HANDLE_TOTAL_DEPTH - 4;
// CC_HANDLE_HEIGHT = 2;

// Cover plane, same height as forward screen plane + margin except at the bottom
function cc_cover_plane(dist) =
    // Generate plane for given distance from the screen plane
    // Bottom corner rounding is applied later
    let(
        extra_bot = sign(dist) * ang_adj_to_opp(KBD_TOP_A + SCR_FWD_A, abs(dist)),

        shape = [
            [0 - CC_COVER_MARGIN, 0 - extra_bot],                                   // bottom left
            [0 - CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],                // top left
            [cc_mask_width + CC_COVER_MARGIN, scr_fwd_height + CC_COVER_MARGIN],    // top right
            [cc_mask_width + CC_COVER_MARGIN, 0 - extra_bot]                        // bottom right
        ],

        radii = [0, CC_TL_R, CC_TR_R, 0]
    )
    round_corners(shape, radius = radii, $fn=fn_where_needed);

module cc_bottom_corner_mask() {
    // Rounding for bottom corners
    // Needs to be applied after skin(), because it causes different
    // count of vertices between front and back side of the cover

    // Bottom corner mask depth, needs to clear CC_B_R at an angle
    mask_depth = CC_B_R * 2;

    // Duplicate for the near corner
    zflip_copy(z = cc_mask_width / 2)
        // Top corner of the mask should be perpendicular to the cover, not to the keyboard surface
        difference() {
            // Rotate the mask to match cassette_mask angle, centered on the back face corner which is [0, 0, 0]
            zrot(KBD_TOP_A + SCR_FWD_A)
                yrot(-90) // orient relative to the model
                    rounding_edge_mask(
                        l = mask_depth,
                        r = CC_B_R,
                        excess = CC_COVER_MARGIN + DELTA
                    );

            ymove(CC_B_R)
                cuboid(
                    mask_depth,
                    anchor = FRONT
                );
        }
}

// cc_bottom_corner_mask();

module cc_cover() {
    // Position the forward face
    fwd_face = apply(
        // Transformations are applied last to first
        IDENT
            * xmove(-CC_VISIBLE_DEPTH) // cover depth
            * yrot(-90), // orient relative to the model
        path3d(cc_cover_plane(CC_VISIBLE_DEPTH))
    );
    // stroke(fwd_face, closed=true);

    // Position the back face
    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * yrot(-90), // orient relative to the model
        path3d(cc_cover_plane(0))
    );
    // stroke(back_face, closed=true);

    // Angle and move the cover together with the corner mask
    move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
        zrot(-SCR_FWD_A)
            difference() {
                // Cover without the bottom corners
                faces = [fwd_face, back_face];
                skin(faces, slices = 10);

                cc_bottom_corner_mask();
            }
}

// %polygon(cc_cover_plane(CC_VISIBLE_DEPTH));
// polygon(cc_cover_plane(0));

// use <body.scad>
// xrot(90) {
//     %body(true);
//     cc_cover();
// }

xrot(90)
    cc_cover();
