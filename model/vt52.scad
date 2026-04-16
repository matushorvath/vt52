// use
include <common.scad>
include <BOSL2/std.scad>

use <body.scad>
use <keyboard.scad>
use <keyboard_position.scad>
use <screen.scad>
use <shell.scad>
use <top_louvres.scad>

// TODO right side dark cover
// TODO bottom cover
// TODO keyboard plate
// TODO try to put "DIGITAL decscope" near the backspace

// Orient the model for easy viewing in OpenSCAD
xrot(90) {
    shell();

    // Cassette cover
    // TODO enable
    //cc_cover();
}
