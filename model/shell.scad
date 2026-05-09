// use
include <common.scad>
include <body_dimensions.scad>
include <BOSL2/std.scad>

use <body.scad>
use <cassette_mask.scad>
use <keyboard.scad>
use <keyboard_position.scad>
use <screen.scad>
use <top_louvres.scad>

// TODO screen mounting features
// TODO screws between body and base
// TODO mount the keyboard USB board
// TODO consider adding fake panel borders on top

module shell() {
    // Move the shell up so it starts at Y=0 (and base will end at Y=0)
    ymove(EXTEND_Y)
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

            // Mask the screen cavity
            screen_mask();

            // Mask the cassette cover cavity
            cc_mask();

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
