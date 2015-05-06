Pig Latin Translator
====================

GTK program written in Vala that translates the input text into pig latin.

Building
------------

    make

Packaging
--------------

    Source: pig-latin
    Section: utils
    Priority: optional
    Maintainer: Alex Gleason <alex@alexgleason.me>
    Build-Depends: debhelper (>= 8.0.0),
                   valac (>= 0.22),
                   libgranite-dev (>= 0.3.0),
                   libgtk-3-dev (>= 3.10)
    Standards-Version: 3.9.4
    Homepage: https://github.com/alexgleason/pig-latin
    Vcs-Git: https://github.com/alexgleason/pig-latin.git
    Vcs-Browser: https://github.com/alexgleason/pig-latin

    Package: pig-latin
    Architecture: any
    Depends: ${shlibs:Depends}, ${misc:Depends}
    Description: An encoder of frivolous jargon.
