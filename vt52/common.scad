include <../common/constants.scad>

$fa = $preview ? 24 : 6;
fn_where_needed = $preview ? 12 : 64;

function cotan(angle) = 1 / tan(angle);

// Scaling factor for the whole model
// except parts that have fixed size (like the keyboard and LCD panel)
SCALE = 0.67;
