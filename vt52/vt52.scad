include <common.scad>
include <body.scad>
include <screen.scad>
include <BOSL2/std.scad>

xrot(90) // orient the model for easy viewing in OpenSCAD
    difference() {
        body();
        screen_mask();
    }
