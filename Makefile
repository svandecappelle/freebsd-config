# Builder of the FreeBSD dwm configuration

all:
	cd dwm && make && cd ..
	cd st && make && cd ..

install: all
	cd dwm && sudo make install && cd ..
	cd st && sudo make install && cd ..
	sudo ./post-install.sh
	mkdir -p ~/.config
	mkdir -p ~/.dwm
	cp -r ./config/ ~/.config/
	cp -r .dwm/ ~/.dwm/

.PHONY: all install
