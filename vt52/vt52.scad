include <common.scad>
include <body.scad>
include <screen.scad>
include <BOSL2/std.scad>

xrot(90) // orient the model for easy viewing in OpenSCAD
    difference() {
        body();

        left(DELTA) // TODO move inside the mask itself
            screen_mask();
    }
