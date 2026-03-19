Dimensions
----------

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


Links
-----

https://terminals-wiki.org/wiki/index.php/DEC_VT52
https://www.youtube.com/watch?v=bAafRXddfxc


References
----------

Where not explicitly mentioned, Sheet comments refer to:
VT50 Field Maintenance Print Set
Digital Equipment Corporation, 1975-02-19
https://manx-docs.org/details.php/1,21903
md5 f75c52b84aa6dbe546e11d6d0cf669f5


Design Notes
------------

I could probably directly use curves from the data tables, with smoothing,
instead of trying to model the curves analytically.
 - body_yz_half_plane could return a smoothed path based on the data tables


Keyboard and Display
--------------------

60% keyboard is around 310mm
8" LCD panel is around 165mm x 120mm

terminal keyboard width is at least 235mm * 2 = 470mm (Sheet 5)
terminal screen width is at least 222+48 - ~2*10 = ~250mm (Sheet 2)
terminal screen height is at least (264 - ~30) - ~50 = ~235 - 50 = ~180mm (Sheet 2)

with a 2:3 scale, it's
470*2/3 = 313, enough for the keyboard
250*2/3 = 167, enough for the panel
180*2/3 = 120, enough for the panel
