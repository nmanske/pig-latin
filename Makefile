# Where to put executable commands on 'make install'?
BIN			= $(DESTDIR)/usr/bin
# Where to put icons on 'make install'?
ICONS		= $(DESTDIR)/usr/share/icons/hicolor/scalable/apps
# Where to put .desktop on 'make install'?
SHORTCUT	= $(DESTDIR)/usr/share/applications

all:
	mkdir -p _build
	valac --pkg gtk+-3.0 --pkg granite -o _build/pig-latin src/*.vala
clean:
	rm -rf _build
install:
	install -d $(BIN) $(ICONS) $(SHORTCUT)
	install _build/pig-latin $(BIN)
	install data/pig-latin.desktop $(SHORTCUT)
	install data/pig-latin.svg $(ICONS)
