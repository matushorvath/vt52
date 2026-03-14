include <../common/constants.scad>

$fa = 1;
$fn = 50;

function cotan(angle) = 1 / tan(angle);

// Scaling factor for the whole model
// except parts that have fixed size (like the keyboard and LCD panel)
SCALE = 0.67;
