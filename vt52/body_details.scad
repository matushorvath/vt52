include <common.scad>
include <body_dimensions.scad>
include <BOSL2/std.scad>

module kbd_front_one_corner_mask() {
    // X offset of the front top edge of the keyboard, in relation to bottom front
    front_corner_shift_x = KBD_FRONT_Y * tan(KBD_FRONT_A);

    // Make the mask high enough to cover the sloped keyboard section, this also affects the shift
    height_multiplier = 2;

    xrot(-90)
        down(DELTA)
            linear_sweep(
                mask2d_roundover(r = ZX_FRONT_CORNER_R),
                height = KBD_FRONT_Y * height_multiplier,
                shift = [front_corner_shift_x * height_multiplier, KBD_FRONT_CORNER_ADJ_TOP_Y * height_multiplier]
            );
}

module kbd_front_corners_mask() {
    // Near side
    up(YZ_BOTTOM_HALF[0] + KBD_FRONT_CORNER_ADJ_BOTTOM_Y)
        kbd_front_one_corner_mask();


    // Far side
    zflip()
        up(YZ_BOTTOM_HALF[0] + KBD_FRONT_CORNER_ADJ_BOTTOM_Y)
            kbd_front_one_corner_mask();
}

//kbd_front_corners_mask();
