Blok
====

Building blocks for UI

About
-----

Blok is a UI framework for Haxe designed to be simple and free of dependencies or DSLs. Everything is written in normal Haxe, with just a little macro magic to make things simpler.

Packages
--------

Packages will be split out eventually, but they're all in one place for now (for ease of development and because I'm not sure what works best yet).

- [blok.core](packages/core): The base implementation used everywhere.
- [blok.core.style](packages/core.style): Blok's (optional) style system.
- [blok.core.html](packages/core.html): Blok's HTML implementation (used by the DOM and Static platforms).
- [blok.platform.dom](packages/platform.dom): Implementation for browsers.
- [blok.platform.static](packages/platform.static): Static HTML rendering.
- [blok.platform.h2d](packages/platform.h2d): Implementation for heaps.

Getting Started
---------------

Blok is in too much flux for a good tutorial to be viable. Check out the [example](example) folder to see the library in use for the time being. The [todomvc](example/todomvc/Main.hx) example is fairly comprehensible and documented.

Frankly you shouldn't use this yet anyway!

If you _are_ interested, however, the way to make this work is to:
- Clone this repo somewhere
- Using [Lix](https://github.com/lix-pm), manually create a file for each of the blok packages you need in the [haxe_libaries](haxe_libraries) folder. This repository actually uses that method -- take a look there to get an idea of what to do.

This is obviously _not_ useful for anything but playing around. Use at your own risk.
