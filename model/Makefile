TARGETS=shell.stl vt52.stl
PREVIEWS=$(TARGETS:.stl=.png)

all: $(TARGETS)
preview: $(PREVIEWS)

include $(wildcard *.deps)

# Detect OpenSCAD location
ifneq ($(shell wslinfo --version),)
	OPENSCAD="/mnt/c/Program Files/OpenSCAD/openscad.exe"
else ifeq ($(shell uname -s),Darwin)
	OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
else
	OPENSCAD=openscad
endif

define run-openscad
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -d $@.deps $< ; \
	EXIT_CODE=$$? ; \
	sed -i -e 's/C:/\/mnt\/c/g' $@.deps ; \
	exit $$EXIT_CODE
endef

%.stl: %.scad
	$(run-openscad)

# Aspect ratio and camera position matches vt52-wikipedia.png
%.png: OPENSCAD_FLAGS = --projection=p --camera=170,0,110,70,0,-115,1400 \
	--imgsize=1452,1080 --colorscheme=Monotone --render
%.png: %.scad
	$(run-openscad)

clean:
	rm -f $(TARGETS) $(PREVIEWS) *.deps

.PHONY: all preview clean
