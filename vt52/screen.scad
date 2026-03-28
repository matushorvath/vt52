include <common.scad>
include <screen_bottom_details.scad>
include <screen_dimensions.scad>
include <screen_planes.scad>
include <screen_top_details.scad>
include <BOSL2/std.scad>

module screen_object(mask) {
    // Mask extends in front of the screen area to clear the keyboard/screen fillet

    // In Z, align center of the extra face with center of the forward face
    extra_shift_z = scr_fwd_center_z - scr_extra_width / 2;

    // Position the extra face
    extra_face = mask ? apply(
        // Transformations are applied last to first
        IDENT
            * move([scr_extra_bottom_x, scr_extra_bottom_y, extra_shift_z]) // move to position relative to the model
            * rot(a = -SCR_FWD_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_extra_plane(mask))
    ) : undef;
    //stroke(extra_face, closed=true);

    // Position the forward face
    fwd_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([scr_fwd_bottom_x, scr_fwd_bottom_y, SCR_FWD_LEFT_Z]) // move to position relative to the model
            * rot(a = -SCR_FWD_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_fwd_plane(mask))
    );
    //stroke(fwd_face, closed=true);

    // In Z, align center of the back face with center of the forward face
    back_shift_z = scr_fwd_center_z - SCR_BACK_WIDTH / 2;

    // Position the back face
    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * xmove(mask ? DELTA : 0) // punch the mask through the back face // TODO remove once we have spheric back face
            * move([scr_back_bottom_x, scr_back_bottom_y, back_shift_z]) // move to position relative to the model
            * rot(a = -SCR_BACK_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_back_plane(mask))
    );
    //stroke(back_face, closed=true);

    // TODO Sheet 2, View K-K: back face is 635 R spherical cut off; SCR_BACK_CENTER_X is touch point to the sphere
    // extend the mask further back since back corners are further inside than now, mask off back face with a 635 R sphere

    faces = mask ? [extra_face, fwd_face, back_face] : [fwd_face, back_face];
    skin(faces, slices = 10);
}

module screen_bottom_bezel_move() {
    move([SCR_INDENT_FWD_X, scr_indent_fwd_y, -SCR_INDENT_LEFT_Z]) // move to position relative to the model
        zrot(KBD_TOP_A)
            children();
}

module screen_bug_move() {
    move([SCR_BUG_BACK_X, scr_bug_back_y, scr_fwd_center_z])
        zrot(KBD_TOP_A)
            children();
}

module screen_louvres_move() {
    move([scr_fwd_top_x, SCR_FWD_TOP_Y, scr_fwd_center_z])
        zrot(-scr_top_a)
            children();
}

// screen_solid(true);
// %screen_solid(false);

// Solid part of the screen, which will form the bezels
module screen_bezels() {
    screen_object(false);
}

// Mask of the screen, which creates the viewport
module screen_mask() {
    difference() {
        union() {
            screen_object(true);

            screen_bottom_bezel_move() ymove(DELTA)
                screen_bottom_bezel_mask_flat();

            screen_bug_move() ymove(DELTA)
                bug_negative();

            screen_louvres_move() ymove(-DELTA)
                screen_louvres();
        }

        screen_bug_move() ymove(-DELTA)
            bug_positive();
    }
}

//screen_bezels();
//%screen_mask();
