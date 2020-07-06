Styles
======

Now that we have a basic framework in place, it's time to think about building out the `blok.style` library. You should be able to do everything you can with standard CSS using it, just with a very different API.

However I don't want to just remake CSS with all its weirdness -- we should instead try to make `blok` the `elm-ui` of haxe. By which I mean we should steal its ideas and implement them with our Style system. This might also require some custom Components to make the styles work right -- we could perhaps have a `blok.ui` package and get rid of `blok.style` and `blok.component`
