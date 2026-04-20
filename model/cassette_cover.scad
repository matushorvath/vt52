// use
include <common.scad>
include <cassette_dimensions.scad>
include <BOSL2/std.scad>

module cc_cover_handle() {
    move([
        -CC_VISIBLE_DEPTH + DELTA,
        scr_fwd_height - CC_HANDLE_POS,
        CC_HANDLE_MARGIN_Z
    ])
        cuboid(
            [CC_HANDLE_DEPTH, CC_HANDLE_HEIGHT, cc_mask_width - 2 * CC_HANDLE_MARGIN_Z],
            rounding = CC_HANDLE_R,
            edges = [LEFT + TOP, LEFT + BOTTOM],
            anchor = RIGHT + BOTTOM + FRONT
        );
}

//cc_cover_handle();

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

//%polygon(cc_cover_plane(CC_VISIBLE_DEPTH));
//polygon(cc_cover_plane(0));

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

//cc_bottom_corner_mask();

module cc_cover_top_bezel() {
    move([
        DELTA,
        scr_fwd_height - CC_BEZEL_WIDTH - CC_COVER_FIT,
        CC_BEZEL_POSITION
    ])
        cuboid([
                BODY_WALL + CC_BEZEL_EXTRA_DEPTH,
                CC_BEZEL_WIDTH,
                cc_mask_width - 2 * CC_BEZEL_POSITION
            ],
            anchor = LEFT + BOTTOM + FRONT
        );
}

module cc_cover_side_bezel() {
    move([
        DELTA,
        CC_BEZEL_POSITION,
        CC_COVER_FIT
    ])
        // Use diff, not difference, so we can position the gaps and the ball with the same operation
        diff() {
            bezel_side_height = scr_fwd_height - 2 * CC_BEZEL_POSITION;

            // Bezel side body
            cuboid([
                    BODY_WALL + CC_BEZEL_EXTRA_DEPTH,
                    bezel_side_height,
                    CC_BEZEL_WIDTH
                ],
                anchor = LEFT + BOTTOM + FRONT
            );

            // Mounting points (two sets of two gaps and and a ball)
            move([DELTA, bezel_side_height / 2, -DELTA]) // move mount points relative to bezel body
                ycopies(CC_MOUNT_DISTANCE + CC_MOUNT_LENGTH + CC_MOUNT_GAP) { // two pairs of mounting points per bezel side
                    ycopies(CC_MOUNT_LENGTH + CC_MOUNT_GAP) // two gaps around each mounting point
                        // Gaps around mounting points, to make them flexible
                        tag("remove") cuboid([
                                BODY_WALL + CC_BEZEL_EXTRA_DEPTH + 2 * DELTA,
                                CC_MOUNT_GAP,
                                CC_BEZEL_WIDTH + 2 * DELTA
                            ],
                            anchor = LEFT + BOTTOM
                        );

                    // Mounting point ball
                    move([
                        BODY_WALL - CC_MOUNT_BALL_FIT, // ball starts right behind the wall, with a small delta to make the fit tight
                        0,
                        CC_MOUNT_BALL_R - CC_COVER_INTERFERENCE // 
                    ])
                        bottom_half(z = CC_COVER_INTERFERENCE - CC_MOUNT_BALL_R + DELTA)
                            sphere(
                                r = CC_MOUNT_BALL_R,
                                anchor = LEFT
                            );
                }
        }
}

module cc_cover_mounts() {
    cc_cover_top_bezel();

    zflip_copy(z = cc_mask_width / 2)
        cc_cover_side_bezel();
}

//cc_cover_mounts();

module cc_cover_object() {
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

    // Cover without the bottom corners
    faces = [fwd_face, back_face];
    skin(faces, slices = 10);
}

//cc_cover_object();

module cc_cover() {
    // Angle and move the cover together with the corner mask
    move([kbd_back_x, kbd_back_y, CC_MASK_LEFT_Z]) // move to position relative to the model
        zrot(-SCR_FWD_A) // angle relative to the model
            difference() {
                union() {
                    cc_cover_object();
                    cc_cover_mounts();
                    cc_cover_handle();
                }

                cc_bottom_corner_mask();
            }
}

// use <body.scad>
// xrot(90) {
//     %body(true);
//     cc_cover();
// }

xrot(90)
    cc_cover();
