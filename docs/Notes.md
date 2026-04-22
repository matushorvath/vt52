Dimensions
==========

Dimensions              Millimeters Inches
A. Height               360         14.1
B. Width                530         20.9
C. Depth                690         27.2
D. Minimum Table Depth  450         17.2
E. AC Line Cord Length  2438        96.0
F. Interface Cable      *           *

see cp-8219.png
https://www.vt100.net/docs/vt52-mm/chapter2.html#S2.1

Detailed drawings:
https://manx-docs.org/details.php/1,21903
https://bitsavers.org/pdf/dec/terminal/vt50/VT50-print-set.pdf
https://bitsavers.org/pdf/dec/terminal/vt50/MP00036_VT50_Maintenance_Drawings_Jan1976.pdf

Color/finish:
https://www.bitsavers.org/pdf/dec/standards/EL-00092-00-0_F_Finish_and_Color_Standard_Dec82.pdf


Links
=====

https://terminals-wiki.org/wiki/index.php/DEC_VT52
https://www.youtube.com/watch?v=bAafRXddfxc


References
==========

Where not explicitly mentioned, Sheet comments refer to:
VT50 Field Maintenance Print Set
Digital Equipment Corporation, 1975-02-19
https://manx-docs.org/details.php/1,21903
md5 f75c52b84aa6dbe546e11d6d0cf669f5


Design Notes
============

I could probably directly use curves from the data tables, with smoothing,
instead of trying to model the curves analytically.
 - body_yz_half_plane could return a smoothed path based on the data tables


Keyboard and Display
====================

60% keyboard is around 310mm
8" LCD panel is around 165mm x 120mm

terminal keyboard width is at least 235mm * 2 = 470mm (Sheet 5)
terminal screen width is at least 222+48 - ~2*10 = ~250mm (Sheet 2)
terminal screen height is at least (264 - ~30) - ~50 = ~235 - 50 = ~180mm (Sheet 2)

with a 2:3 scale, it's
470*2/3 = 313, enough for the keyboard
250*2/3 = 167, enough for the panel
180*2/3 = 120, enough for the panel


Keyboard Depth
==============

ECHO: "kbd_fwd_x", 7.79423
ECHO: "KBD_FWD_Y", 13.5
ECHO: "kbd_back_x", 130.303
ECHO: "kbd_back_y", 41.7833

KBD_TOP_A = 13;
KBD_BACK_R = 14;

dX = 122.5
dY = 28.3
dist = sqrt(dX^2 + dY^2) = 125.7

dist_scale = dist * 2/3 = 83.8

real keyboard depth rdist_scale = 100 (keys only 95, +5 for front support)
rdist = rdist_scale * 3/2 = 150

delta = rdist - dist = 24.3

-> we need to find extra 25 depth for keyboard
plus front bezel, plus a bit if space behind keyboard, say 30

issue: We can't just extend the space, it affects other parts as well.
If we just extend it, we need to choose:
1. the front edge gets shorter; or
  - could be acceptable, need to calculate how much
  - we need to extend the side curves, but we can probably just scale the spacing
    between YZ planes them from 50 to a bit more in the keyboard part of the model
2. the whole model gets taller; or
  - could be acceptable, it's the same amount as option 1
  - but we need to think about the side curves, they're defined for a specific model height
    (they could be scaled in the bottom part of the model)
3. the keyboard angle, which is also the bottom screen angle, gets smaller
  - probably would make the model look funny unless it's very small

Maybe the solution is a combination of multiple options.
(e.g. angle from 13 to 12 and shorten the front edge)

Also, the angle defines keyboard length, but other X lengths are absolute numbers
and would have to be adjusted manually. It's not trivial to adjust the model.
One option would be to extend the model to negative X (option 1) or negative Y (option 2)


Calculations
------------

Option 1:
To get additional 30 on the hyp, adjust X and Y:

sin(KBD_TOP_A) = adjY / hyp
adjY = sin(13) * 30 = 6.7 (out of 13.5, a half)

cos(KBD_TOP_A) = adjX / hyp
adjX = cos(13) * 30 = 29.2

For example, extend the model to -Y by 5, make the front edge shorter by 1.7,
which moves the front edge to -X by 29
=> extendY is 29, adjEdgeY is 1.7


Implementation
--------------

Try to keep the adjustments isolated as much as possible.
That's why we extend to -X and -Y, so the rest of the model can be untouched.

Rough plan:
- DONE Extend the XY plane to -X and -Y, making the front edge shorter.
- DONE Extend the YZ planes to -Y by scaling up the curves.
  - Simplest is to take bottom kbd_back_y = 41.8 and scale that up to kbd_back_y + 5 = 18.5.
  - Perhaps that will create a visible crease, check.
- DONE Extend spaces between YZ planes where x < kbd_back_x by linearly scaling them.
  - Perhaps that will create a visible crease, check.
- DONE Move the front corners.
- Keep the keyboard/bottom screen angle unchanged.


Performance
===========

- use $fa instead of $fn since it scales with size
- use render() around nested set operations
- lower $fn during modeling, e.g. to 16
- simple models for preview, e.g. simplify the table based curves


Videos
======

https://www.youtube.com/watch?v=nb2bxaj79rc
https://www.youtube.com/watch?v=ksL232PHivI
https://www.youtube.com/watch?v=3gNN4nL5F-k


TODOs
=====

- rename outside to !mask in body models
- terminal top and bottom are an interference between the two body planes, you can see it if you color body_xy red
- screen bezel and cassette mask interfere with keyboard surface, move screen bezel/cassette mask back by DELTA?
- move some of the _dimensions that are not shared between files into the .scad file that uses them
  - comment out dimensions that are not yet used at all
- Section AK-AK Sheet 10: Display top has 5 stiffening ribs
  - add stiffening ribs to other places as well
- rotate the model for easy viewing (needs also adjusting make preview)


Base
====

Page 25, Sheet 13 - side outline
Page 41, Sheet 29, Data List 1 - side outline curve
  - it's partly already in the model
Pages 59-61 - base drawings
  - bottom shape is defined in page 61
Page 62 - base below the keyboard, for angles
  - fwd bottom base is 21 degrees to keyboard (Page 62)
  - fwd bottom base is 21 - KBD_TOP_A = 21 - 13 = 8 degrees to horizontal

bottom shape:
  - try defining it with cuts along X, starting just behind the front corners (24.5 REF P61 Right Side)
  - use Section E-E, Section F-F for the cuts
    - behind 241.8 it's all constant Section F-F
    - might move that to the front, since we are finishing at X = 250 currently
  - need to redesign feet locations
    - perhaps use the original front foot as back foot
    - add a new front foot, something subtle below the keyboard, but make sure it doesn't wobble
    - e.g. a bar along Z, a bit behind X=24.5 REF (end of corners) but not too much, maybe X=30,
      with margins in Z to make it less obvious
    - pressing on space bar must be supported without wobble, perhaps put the front feet below space bar in X
    - design exact dimensions for obtainable rubber feet
  - front corners
    - complex shape, blend from horizontal radius to vertical radius
    - maybe model that with a 2d shape extruded along a curve, possibly a circle or ellipse section
      (P61 RIGHT SIDE looks like perhaps it's even a parabole)
    - design the curve:
      - front tangent should be vertical
      - back tangent should be similar to but not exact: P62 21 - KBD_TOP_A = 21 - 13 = 8 degrees to horizontal
      - P61 says the two points of tangency should blend with surrounding areas, so perhaps the whole
        E-E to F-F section is extruded along a curve, or perhaps calculate more cuts and make them form a curve in Y,
        that is continuous with before E-E and after F-F
        - or ask BOSL2 to make it continuous if it can

first design:
  - make 2 cuts E-E and F-F
  - somehow convince BOSL2 to use defined angles when connecting to the cuts
  - or make fake cuts before and after that define those angles
  - connect with a straight F-F to back section
  - connect with a front to E-E section
