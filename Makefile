all:
	make -C model all

preview:
	make -C model preview

clean:
	make -C model clean

.PHONY: all preview clean
