include <common.scad>
include <body.scad> // TODO remove
include <screen_dimensions.scad>
include <screen_planes.scad>
include <BOSL2/std.scad>

module screen_mask() {
    // Position the front face
    front_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([kbd_back_x, kbd_back_y, -SCR_FRONT_LEFT_Z]) // move to position relative to the model
            * rot(a = -SCR_FRONT_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_front_plane())
    );

    //stroke(front_face, closed=true);

    // Position the back face

    // In X and Y: depends on distance between front and back centers, as well as the keyboard angle
    // TODO this is just temporary
    // TODO SCR_BACK_SCREEN_X, SCR_BACK_SCREEN_Y
    back_shift_x = 200;
    back_shift_y = 50;

    // In Z: Align center of back face with center of front face
    back_shift_z = SCR_FRONT_CENTER_Z + SCR_PANEL_X / 2 - SCR_PANEL_MARGIN;

    back_face = apply(
        // Transformations are applied last to first
        IDENT
            * move([back_shift_x, back_shift_y, -back_shift_z]) // move to position relative to the model
            * rot(a = -SCR_BACK_SCREEN_A, v = [0, 0, 1]) // angle relative to the model
            * rot(a = -90, v = [0, 1, 0]), // orient relative to the model
        path3d(screen_back_plane())
    );

    //stroke(back_face, closed=true);

    skin([front_face, back_face], slices = 10);
}

// TODO extend the mask above the keyboard, because we need to cut off the filled behind the keyboard
// TODO add small features - cutout, bug, ribs
// TODO add front bezel border ? if it exists

// TODO temp
difference() {
     body();

     left(DELTA)
        screen_mask();
}
