TARGETS=vt52.stl
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

%.png: OPENSCAD_FLAGS = --autocenter --viewall --projection=p --camera=0,0,150,100,50,100 \
	--imgsize=2880,2160 --colorscheme=Monotone --render=true
%.png: %.scad
	$(run-openscad)

clean:
	rm -f $(TARGETS) $(PREVIEWS) *.deps

.PHONY: all preview clean
