include <common.scad>
include <body_dimensions.scad>
include <keyboard_dimensions.scad>
include <keyboard.scad>
include <BOSL2/std.scad>

include <body.scad> // TODO remove

// TODO
// - angle the keyboard by KBD_TOP_A
// - design mounting hardware
//   - pins for the holes, they will be fragile, stiffen them
//   - rests for the dampers, top and bottom
//   - perhaps brackets for the corners? but not too close
// - locate the keyboard in body
// - find if bottom needs to be adjusted to fit

// - try to use the soft foam and silicon that was below the keyboard
// - don't forget about the USB board
//   - USB board connects between left shift and Z

// - add positive mounting features
//   - but also, how mounting features will attach to the body depends on keyboard position
//   - perhaps add the positive mounting features on a rail with plain bottom,
//     then connect it up when positioning keyboard in body
//   - separate top and bottom features, since they will end up on two objects (body and base)
//   - perhaps angle the plain bottom by KBD_TOP_A (but top actually can stay straight

module k65_move() {
    // Move and angle the keyboard relative to body
    move([
        0,
        0,
        0
        ])
            zrot(KBD_TOP_A)
                children();
}

// Reverse scale the keyboard to make it match the model
// It will get scaled back down to real size when the whole model is resized at the end
module k65_rev_scale() {
    scale(1 / SCALE)
        children();
}

xrot(90) {
    k65_move()
        k65_rev_scale()
            k65_mask();

    %body();
}