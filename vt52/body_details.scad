include <common.scad>
include <body_dimensions.scad>
include <BOSL2/std.scad>

module kbd_fwd_one_corner_mask(outside) {
    owall = outside ? 0 : BODY_WALL;

    // X offset of the forward top edge of the keyboard, in relation to bottom forward
    fwd_corner_shift_x = adj_ang_to_opp(KBD_FWD_Y, KBD_FWD_A);

    // Make the mask high enough to cover the sloped keyboard section, this also affects the shift
    height_multiplier = 2;

    xrot(-90)
        down(DELTA)
            linear_sweep(
                mask2d_roundover(r = ZX_FWD_CORNER_R - owall),
                height = KBD_FWD_Y * height_multiplier,
                shift = [fwd_corner_shift_x * height_multiplier, KBD_FWD_CORNER_ADJ_TOP_Y * height_multiplier]
            );
}

module kbd_fwd_corners_mask(outside) {
    owall = outside ? 0 : BODY_WALL;

    // Near side
    move([-DELTA + owall, -DELTA, YZ_BOTTOM_HALF[0] + KBD_FWD_CORNER_ADJ_BOTTOM_Y - owall])
        kbd_fwd_one_corner_mask(outside);

    // Far side
    zflip()
        move([-DELTA + owall, -DELTA, YZ_BOTTOM_HALF[0] + KBD_FWD_CORNER_ADJ_BOTTOM_Y - owall])
            kbd_fwd_one_corner_mask(outside);
}

// %kbd_fwd_corners_mask(true);
// kbd_fwd_corners_mask(false);
