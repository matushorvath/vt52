TARGETS=cassette_cover.stl shell.stl vt52.stl
PREVIEWS=$(TARGETS:.stl=.png)

all: $(TARGETS)
preview: $(PREVIEWS)

-include $(wildcard *.deps)

OPENSCAD=openscad

define run-openscad
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -d $@.deps $<
endef

%.stl: %.scad
	$(run-openscad)

# Aspect ratio and camera position matches vt52-wikipedia.png
%.png: OPENSCAD_FLAGS = --projection=o --camera=170,0,110,70,0,-115,1400 \
	--imgsize=1452,1080 --colorscheme=Monotone --render
%.png: %.scad
	$(run-openscad)

clean:
	rm -f $(TARGETS) $(PREVIEWS) *.deps

.PHONY: all clean preview version-check
