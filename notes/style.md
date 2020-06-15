Style
=====

More thinking on styles, as I think the current way I'm doing things won't work.

I think we need to lean more into the VNode-like approach more. Something like this:

```haxe
package example.style;

using Blok;

class Container extends Style {

  @prop var padding:Unit = null;
  @prop var margin:Unit = null;

  override function build(context:Context):Array<VStyle> {
    return [
      VProperty('margin', VDynamicValye(margin)),
      VProperty('padding', VDynamicValye(padding)),
    ];
  }

}

```

This can be used in components like this:

```haxe
package example;

import example.style.Container;

using Blok;

class Section extends Component {

  @prop var children:Children;

  override function render(context:Context) {
    return Html.div({
      style: Container.style({ padding: Px(10) }),
      children: children
    });
  }

}

```

This is where things get a bit more complicated. `Container.style` does not return an instance: instead, you get this:

```haxe

VStyleDecl.VCustomStyle(Container, { padding: Px(10) });

```

... where `Container` is a `StyleType`:

```haxe
typedef StyleType<Props:{}> = {
  __getName(attrs:Props):String;
  __render(attrs:Props):String;
}
```

(note that `VStyleDecl` can also be `VStyleName(name:String)`, which will allow the user to pass a generic CSS name along).

Internally, Block will run the following algorithm (or something similar). Note that it's only computing the new class name -- ONLY if the name does not exist is the Style class instantiated and rendered:

```haxe

function parseStyle(style:VStyleDecl):String {
  switch style {
    case VCustomStyle(type, attrs):
      var name = type.__getName(attrs);
      if (!context.styleEngine.exists(name)) {
        context.styleEngine.define(name, () -> type.__render(attrs));
      }
    case VStyleName(name):
      return name;
  }
}

```

A style's name is derived from its class name plus dynamic properties, so this example would be called `.example-style-Container--_-10px`.

Blok would provide a number of basic styles, such as Layout and Box:

```haxe
package blok.style;

import block.core.Style;
import block.core.VStyle;

class Box extends Style {

  @prop var padding:BoxRect = BoxRect.all(Num(0));
  @prop var margins:BoxRect = BoxRect.all(Num(0));
  @prop var background:Background = Background.inheritColor();

  override function render(context:Context):Array<VStyle> {
    return [
      VProperty('display', SingleValue('flex')),
      VProperty('padding', padding),
      VProperty('margin', margin)
    ];
  }

}

```

In this example, `BoxRect` is a `blok.core.VStyleValue`:

```haxe
package blok.style;

import block.core.VStyleValue

abstract BoxRect(VStyleValue) to VStyleValue {

  public inline static function all(unit:Unit) {
    return new BoxRect({
      top: unit,
      right: unit,
      bottom: unit,
      left: unit
    });
  }

  public inline function new(props:{ 
    ?top:Unit, 
    ?right:Unit, 
    ?bottom:Unit,
    ?left:Unit 
  }) {
    this = CompoundValue([
      SingleValue(props.top != null ? props.top : 0),
      SingleValue(props.right != null ? props.right : 0),
      SingleValue(props.bottom != null ? props.bottom : 0),
      SingleValue(props.left != null ? props.left : 0),
    ]));
  }

}

```

You get the idea.
