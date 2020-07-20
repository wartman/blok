Refactor
========

The current API works all right, but I want this to be more flexible.

Here's some thinking on the Refactor:

- Style data should be completely decoupled from CSS. An underlying StyleEngine will be provided by each Platform that will apply styles in whatever way makes sense (either directly to an object or by generating CSS for a browser and adding a class name).
- In addition, the `blok.css` and `blok.html` packages should be merged into `blok.platform.dom`. The `NodeComponent` class should also be moved there.
- In general we should rethink file organization. Things feel a bit all over the place at the moment.
- Also we should try simplifying the code as much as possible. This library is bigger than it needs to be. 
