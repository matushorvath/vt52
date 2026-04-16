// use
include <common.scad>
include <BOSL2/std.scad>

use <body.scad>
use <keyboard.scad>
use <keyboard_position.scad>
use <screen.scad>
use <top_louvres.scad>

// TODO decorative bezel around
// TODO screen mounting features
// TODO screws between body and base
// TODO texture
// TODO mount the keyboard USB board

module shell() {
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
}

// Orient the model for easy viewing in OpenSCAD
xrot(90)
    shell();
