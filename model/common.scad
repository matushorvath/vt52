// include

DELTA = .01;

fa_value = $preview ? 24 : 6;
fn_value = $preview ? 24 : 64;
$fa = fa_value;

function cotan(angle) = 1 / tan(angle);

// Scaling factor for the whole model
// except parts that have fixed size (like the keyboard and LCD panel)
SCALE = 0.67;
