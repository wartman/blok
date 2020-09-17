Reorganization
==============

This is a big mess now, so here are some plans for cleanup.

- The ui package is just for DOM, it's crazy to try to make it work with h2d too. Move all ui stuff out of the `blok-dom` package into it.
- Create a `blok-html` package -- we can share the code there between the `blok-dom` package and a `blok-static` one. They'll both need CSS and HTML generators.

Packages might look like this:

Core packages (cannot be used without an implementation package):
  - blok-core
  - blok-html
  - blok-css

Implementation packages:
  - blok-dom
    - depends on blok-core, blok-html, blok-css
  - blok-static
    - depends on blok-core, blok-html, blok-css
  - blok-h2d
    - depends on blok-core