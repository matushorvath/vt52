include ../common/openscad.mk

.SUFFIXES: .scad .stl

TARGETS=body.stl
INCLUDES=common.scad

%.stl: %.scad $(INCLUDES)
	$(OPENSCAD) -o $@ $<

.PHONY: all clean

all: $(TARGETS)

clean:
	rm -f $(TARGETS:.scad=.stl)
