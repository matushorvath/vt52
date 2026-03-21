include <common.scad>
include <body.scad>
include <screen_mask.scad>
include <BOSL2/std.scad>

// TODO top edge louvres
// TODO right side dark cover
// TODO bottom cover
// TODO keyboard plate
// TODO decorative bezel around
// TODO spherical cutout of viewport back
// TODO hollow out
// TODO trim terminal depth
// TODO texture

xrot(90) // orient the model for easy viewing in OpenSCAD
    diff() {
        body(true);
        tag("remove") body(false); // TODO maybe move the tag inside body()?

        tag("remove") screen_mask();
    }
