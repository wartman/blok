Reorganization
==============

This is a big mess now, so here are some plans for cleanup.

- The ui package is just for DOM, it's crazy to try to make it work with h2d too. Move all ui stuff out of the `blok-dom` package into it.
- Create a `blok-html` package -- we can share the code there between the `blok-dom` package and a `blok-static` one. They'll both need CSS and HTML generators.

Packages might look like this:

Core packages (cannot be used without an platform package):
  - blok-core
  - blok-html

Platform packages:
  - blok-dom
    - depends on blok-core, blok-html
  - blok-static
    - depends on blok-core, blok-html
  - blok-h2d
    - depends on blok-core

Cleanup
-------

Right now there is a lot of messiness around the fact that we need to have a `<Node>` param in most places to get at the underlying native implementation. For client-side code, however, this can basically be ignored (the only place you'll really see it is if you're dealing with `Ref`).

Life would be a *lot* easier if we could push all thinking about `Node` and other low-level stuff into the Engine. If all a platform package (like `dom` or `static`) contained was an Engine and a Platform class this would all be *way* easier and cleaner.

To think through things (platform-classes are marked with `*`, the rest are core classes -- only `*` classes know about `Node`s):

-> *Platform (`blok.dom.Platform`, `blok.h2d.Platform`, etc.)
  -> Components
    -> Differ
      -> VNode Tree
        -> *Engine (also handles Style rendering, like now)
          -> *Node

The only thing we'll need to figure out is how to handle `ref` properly. Might just really discourage it instead -- especially if we want this thing to be cross platform. We might expose another API for things like Inputs (which are really the only place we're using `ref`) akin to what Elm does. 
