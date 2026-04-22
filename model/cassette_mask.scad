// use
include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

// TODO original has a lip around the hole, consider doing that, perhaps the cover holds better
// e.g. Page 57, Sheet 45

// Mask off top part of the R14 kbd/scr fillet to make space for the cover corner
// See also the cuboid we diff in cc_bottom_corner_mask()
module cc_mask_bottom_corners() {
    // Mask depth must be more than max(depth of the cover, depth of the relevant part of kbd/scr fillet)
    mask_depth = KBD_BACK_R;

    // Looser fit between the cover and these notches
    z_fit = 0.2;

    // Mirror for near side
    zflip_copy(z = cc_mask_width / 2)
        // Start where the cover corner radius ends, the cover will rest the surface this mask creates
        // DELTA in X is to avoid artifacts on screen face after cc_mask() is applied to the whole body
        move([-DELTA, CC_B_R, DELTA])
            cuboid(
                // Enough depth to clear the kbd/scr fillet (X), height of the remaining part of kbd/scr
                // fillet above the cover corner radius (Y), width of the cover margin (Z)
                [mask_depth, KBD_BACK_R - CC_B_R + DELTA, CC_COVER_MARGIN + z_fit],
                anchor = FRONT + RIGHT + TOP
            );
}

// cc_mask_bottom_corners();

// Cover mask, same height as forward screen plane
function cc_mask_plane(dist) =
    // Generate plane for given distance from the screen plane
    let(
        extra_top = sign(dist) * ang_adj_to_opp(SCR_FWD_A, abs(dist)),
        extra_bot = sign(dist) * ang_adj_to_opp(KBD_TOP_A + SCR_FWD_A, abs(dist)),

        shape = [
            [0, -extra_bot],                                    // bottom left
            [0, scr_fwd_height - extra_top],                    // top left
            [cc_mask_width, scr_fwd_height - extra_top],        // top right
            [cc_mask_width, -extra_bot],                        // bottom right
        ],

        radii = [CC_B_R, CC_TL_R, CC_TR_R, CC_B_R]
    )
    round_corners(shape, radius = radii);

module cc_mask() {
    // Position the extra face
    extra_face = apply(
        // Transformations are applied last to first
        IDENT
            * xmove(-scr_extra_dist_x) // place in front of the screen plane
            * yrot(-90), // orient relative to the model
        path3d(cc_mask_plane(scr_extra_dist_x))
    );
    //stroke(extra_face, closed=true);

    // Position the forward face
    fwd_face = apply(
        // Transformations are applied last to first
        IDENT
            * yrot(-90), // orient relative to the model
        path3d(cc_mask_plane(0))
    );
    //stroke(fwd_face, closed=true);

    // Position the back face
    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * xmove(BODY_WALL * 2) // make sure to clear the wall at an angle
            * yrot(-90), // orient relative to the model
        path3d(cc_mask_plane(-BODY_WALL * 2))
    );
    //stroke(back_face, closed=true);

    move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
        zrot(-SCR_FWD_A) { // angle relative to the model
            faces = [extra_face, fwd_face, back_face];
            skin(faces, slices = 10);

            cc_mask_bottom_corners();
        }
}

// %polygon(cc_mask_plane(10));
// polygon(cc_mask_plane(0));

// cc_mask();

// use <body.scad>
// xrot(90) {
//     difference() {
//         body(true);
//         cc_mask();
//     }
// }
