Remove Styles
-------------

What it says on the tin, really. Remove the "plugins" thing too. This will simplify Blok a lot, and make it easier to complete.

Instead, we might look into either using something like Cix or implementing our own simple CSS-in-Haxe solution that can be used elsewhere. This will also make Heaps a lot easier to use, as it doesn't really benefit from the way we're doing things.

We can still have a `foundation` package, but styles will be component-based.

```haxe
import blok.core.foundation.ui.*;

using Blok;

class Example extends Component {
  override function render() {
    return Box.node({
      width: Px(200),
      children: [
        Html.text('Yay!')
      ]
    });
  }
}

```

In the background, this will be using some sort of CSS framework.

> Note: this might make sense just to break blok out into its component parts.
