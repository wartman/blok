Styles
======

The current approach is basically just copying css. I think that's a bad plan -- I'd like to use this lib somewhere like Heaps, where we won't have access to a css engine (well we might with domkit, but you get the idea).

Instead, styles should just be data that get passed to a `blok.core.StyleEngine`. The engine will then do different things depending on platform, but on the browser it will create a CSS string and mount it (if the rule does not already exist) and then modify the `class` property on the Component. Or something like that.

On Heaps, the engine will take the rules and apply them directly to the underlying `h2d.Object` (which might involve building shapes).
