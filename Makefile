all:
	make -C model all

preview:
	make -C model preview

clean:
	make -C model clean

check-bosl2:
	./scripts/bosl2_update.sh

install-bosl2:
	./scripts/bosl2_update.sh --install

update-bosl2:
	./scripts/bosl2_update.sh --update

.PHONY: all preview clean check-bosl2 install-bosl2 update-bosl2
