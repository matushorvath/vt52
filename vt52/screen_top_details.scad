include <common.scad>
include <screen_dimensions.scad>
include <BOSL2/std.scad>

module one_louvre_fwd(center_z) {
    move([SCR_LVR1_FWD_X, 0, center_z])
        cuboid(
            [SCR_LVR1_LENGTH_X, SCR_LVR_DEPTH, SCR_LVR1_WIDTH_Z],
            anchor = LEFT + FRONT
        );
}

module one_louvre_back(center_z) {
    move([SCR_LVR2_FWD_X, 0, center_z])
        cuboid(
            [SCR_LVR2_LENGTH_X, SCR_LVR_DEPTH, SCR_LVR2_WIDTH_Z],
            anchor = LEFT + FRONT
        );
}

module louvres() {
    // Forward center
    one_louvre_fwd(0);

    for (i = [1:7]) {
        offset_z = i * (SCR_LVR1_GAP_Z + SCR_LVR1_WIDTH_Z);
        one_louvre_fwd(offset_z);
        one_louvre_fwd(-offset_z);
    }

    // Forward sides
    for (i = [0:1]) {
        offset_z = SCR_LVR2_POS_Z + SCR_LVR1_WIDTH_Z / 2 + i * (SCR_LVR1_GAP_Z + SCR_LVR1_WIDTH_Z);
        one_louvre_fwd(offset_z);
        one_louvre_fwd(-offset_z);
    }

    // Back sides
    offset_z = SCR_LVR2_POS_Z + SCR_LVR2_WIDTH_Z / 2;
    one_louvre_back(offset_z);
    one_louvre_back(-offset_z);
}

louvres();
