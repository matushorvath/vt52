include ../common/openscad.mk

.SUFFIXES: .scad .stl

TARGETS=body.stl

all: $(TARGETS)

include $(wildcard *.deps)

%.stl: %.scad
	$(OPENSCAD) -o $@ -d $@.deps $< ; \
	EXIT_CODE=$$? ; \
	sed -i -e 's/C:/\/mnt\/c/g' $@.deps ; \
	exit $$EXIT_CODE

.PHONY: all clean

clean:
	rm -f $(TARGETS:.scad=.stl) *.deps
