all:
	mkdir -p _build
	valac --pkg gtk+-3.0 --pkg granite -o _build/pig-latin src/*.vala
clean:
	rm -rf _build
install: all
	cp _build/pig-latin /usr/bin
	cp data/pig-latin.desktop /usr/share/applications
	cp data/pig-latin.svg /usr/share/icons/hicolor/scalable/apps/
