// use
include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

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
            * move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * xmove(-scr_extra_dist_x) // place in front of the screen plane
            * yrot(-90), // orient relative to the model
        path3d(cc_mask_plane(scr_extra_dist_x))
    );
    //stroke(extra_face, closed=true);

    // Position the forward face
    fwd_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * yrot(-90), // orient relative to the model
        path3d(cc_mask_plane(0))
    );
    //stroke(fwd_face, closed=true);

    // Position the back face
    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
            * zrot(-SCR_FWD_A) // angle relative to the model
            * xmove(BODY_WALL * 2) // make sure to clear the wall at an angle
            * yrot(-90), // orient relative to the model
        path3d(cc_mask_plane(-BODY_WALL * 2))
    );
    //stroke(back_face, closed=true);

    faces = [extra_face, fwd_face, back_face];
    skin(faces, slices = 10);
}

// %polygon(cc_mask_plane(10));
// polygon(cc_mask_plane(0));

// cc_mask();

// include <body.scad>
// xrot(90) {
//     difference() {
//         body(true);
//         cc_mask();
//     }
// }
