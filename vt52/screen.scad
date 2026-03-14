include <common.scad>
include <screen_dimensions.scad>
include <screen_planes.scad>
include <BOSL2/std.scad>

//polygon(screen_front_plane());
//polygon(screen_back_plane());


// TODO 
//  - scale screen_back_plane based on angle difference between front and back
//    - both X and Y will change, it will be a trapezoid
//    - need to think about it, not sure if it actually works...
//  - rotate screen_back_plane by the same angle, so it is parallel to screen_front_plane
//  - use skin() to generate the shape
//  - cut off the shape at the original position and angle of screen_back_plane
