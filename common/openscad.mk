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

# Color schemes: Cornfield Starnight BeforeDawn DeepOcean Monotone
%.png: OPENSCAD_FLAGS = --autocenter --viewall --projection=p \
	--imgsize=2880,2160 --colorscheme=Monotone --render=true

# Adjust flags for individual models like this:
# %.png: OPENSCAD_FLAGS += --camera=0,0,150,100,50,100
