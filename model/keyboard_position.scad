// use
include <common.scad>
include <body_dimensions.scad>
include <keyboard_dimensions.scad>
include <BOSL2/std.scad>

use <keyboard.scad>

// TODO keyboard
// - design mounting hardware
//   - pins for the holes, they will be fragile, stiffen them
//   - rests for the dampers, top and bottom
// - try to use the soft foam and silicon below the keyboard

// - add positive mounting features
//   - perhaps add the positive mounting features on a rail with plain bottom,
//     then connect it up when positioning keyboard in body
//   - separate top and bottom features, since they will end up on two objects (body and base)
//   - perhaps angle the plain bottom by KBD_TOP_A

// - front top damper rests are part of the front body edge
//   - extend the mask so it's not the exact damper size in Z
//   - make the body front edge thicker, currently the dampers are half-supported

module k65_move_after_rev_scale() {
    // Location of the forward top edge of the body
    front_top_edge = [
        kbd_fwd_x - extend_fwd_top_x,
        KBD_FWD_Y - extend_fwd_top_y,
        0 // z is irrelevant
    ];

    // Move the keyboard left to imitate the original
    zmove(-K65_OFF_CENTER_Z)
        // Rotate keyboard to match the body
        zrot(KBD_TOP_A, cp = front_top_edge)
            // Move they keyboard slightly in to fit the mounting hardware inside the body + create a front margin
            xmove(K65_FRONT_MARGIN)
                // Align forward top edge of the hidden keyboard with forward top edge of the body
                move(front_top_edge)
                    children();
}

// Reverse scale the keyboard to make it match the model
// It will get scaled back down to real size when the whole model is resized at the end
module k65_rev_scale() {
    scale(1 / SCALE)
        children();
}

// Prepare the real-size keyboard for placing into body
module k65_move_before_rev_scale() {
    // Move hidden parts of the keyboard to negative Y;
    // this aligns forward top edge of hidden keyboard with the Z axis
    ymove(-(K65_BOARD_Y + K65_HIDDEN_Y))
        children();
}

module k65_move() {
    k65_move_after_rev_scale()
        k65_rev_scale()
            k65_move_before_rev_scale()
                children();
}
