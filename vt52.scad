include <common.scad>
include <body.scad>
include <screen.scad>
include <top_louvres.scad>
include <keyboard.scad>
include <keyboard_position.scad>
include <BOSL2/std.scad>

// TODO right side dark cover
// TODO bottom cover
// TODO keyboard plate
// TODO decorative bezel around
// TODO screen mounting features
// TODO trim terminal depth
// TODO screws between body and base
// TODO texture
// TODO try to put "DIGITAL decscope" near the backspace
// TODO mount the keyboard USB board

// Orient the model for easy viewing in OpenSCAD
xrot(90)
    difference() {
        union() {
            // Body with a cavity
            difference() {
                body(true);
                body(false);
            }

            // Screen object without the cavity
            screen_bezels();

            // Backing box for the top louvres
            top_louvres_backing();
        }

        // Mask the screen cavity and surrounding parts of the body
        screen_mask();

        // Mask the top louvres
        top_louvres_mask();

        // Mask the keyboard
        k65_move()
            k65_mask();
}
