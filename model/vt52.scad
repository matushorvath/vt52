// use
include <common.scad>
include <BOSL2/std.scad>

use <cassette_cover.scad>
use <shell.scad>

// TODO bottom cover
// TODO keyboard plate
// TODO try to put "DIGITAL decscope" near the backspace

// Orient the model for easy viewing in OpenSCAD
xrot(90) {
    color("moccasin") shell();
    color("dimgray") cc_cover();
}
