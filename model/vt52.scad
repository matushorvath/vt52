// use
include <common.scad>
include <BOSL2/std.scad>

use <cassette_cover.scad>
use <shell.scad>

// TODO finish right side dark cover
// TODO bottom cover
// TODO keyboard plate
// TODO try to put "DIGITAL decscope" near the backspace

// Orient the model for easy viewing in OpenSCAD
xrot(90) {
    shell();
    cc_cover();
}
