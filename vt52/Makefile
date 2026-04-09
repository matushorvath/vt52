include ../common/openscad.mk

.SUFFIXES: .scad .stl

TARGETS=vt52.stl
PREVIEWS=$(TARGETS:.stl=.png)

all: $(TARGETS)
preview: $(PREVIEWS)

include $(wildcard *.deps)

%.stl: %.scad
	$(run-openscad)

%.png: OPENSCAD_FLAGS += --camera=0,0,150,100,50,100
%.png: %.scad
	$(run-openscad)

.PHONY: all preview clean

clean:
	rm -f $(TARGETS) $(PREVIEWS) *.deps
