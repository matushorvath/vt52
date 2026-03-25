include <common.scad>
include <body.scad>
include <screen.scad>
include <BOSL2/std.scad>

// TODO top edge louvres
// TODO right side dark cover
// TODO bottom cover
// TODO keyboard plate
// TODO decorative bezel around
// TODO spherical cutout of viewport back
// TODO trim terminal depth
// TODO texture

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
        }

        // Mask the screen cavity and surrounding parts of the body
        screen_mask();
    }
