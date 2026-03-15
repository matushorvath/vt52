include <common.scad>
include <screen_dimensions.scad>
include <screen_planes.scad>
include <BOSL2/std.scad>

module screen_mask() {
    // In Z, align center of the extra face with center of the forward face
    extra_shift_z = scr_fwd_center_z + scr_extra_width / 2;

    // Position the extra face (for clearing the keyboard/screen fillet)
    extra_face = apply(
        IDENT
            * move([scr_extra_bottom_x, scr_extra_bottom_y, -extra_shift_z]) // move to position relative to the model
            * rot(a = -SCR_FWD_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_extra_plane())
    );

    //stroke(extra_face, closed=true);

    // Position the forward face
    fwd_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([scr_fwd_bottom_x, scr_fwd_bottom_y, -SCR_FWD_LEFT_Z]) // move to position relative to the model
            * rot(a = -SCR_FWD_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_fwd_plane())
    );

    //stroke(fwd_face, closed=true);

    // In Z, align center of the back face with center of the forward face
    back_shift_z = scr_fwd_center_z + SCR_BACK_WIDTH / 2;

    // Position the back face
    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([scr_back_bottom_x, scr_back_bottom_y, -back_shift_z]) // move to position relative to the model
            * rot(a = -SCR_BACK_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_back_plane())
    );

    //stroke(back_face, closed=true);

    move([0, DELTA, 0]) // avoid artifacts on the keyboard surface
        skin([extra_face, fwd_face, back_face], slices = 10);
}

// TODO add small features - cutout, bug, ribs
// TODO add front bezel border ? if it exists

//screen_mask();
