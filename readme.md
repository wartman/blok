Blok
====

Building blocks for UI

About
-----

Blok is a UI framework for Haxe designed to be simple and free of dependencies or DSLs. Everything is written in normal Haxe, with just a little macro magic to make things simpler.

Example
-------

```haxe
using Blok;

class ExampleStyle extends Style {

  @prop var height:Unit;

  override function render():Array<VStyle> {
    return [
      Css.color(0xCCC),
      block.style.Background.export({
        color: blok.style.Color.rgb(0, 0, 0, 0)
      }),
      blok.style.Box.export({
        height: height
      })
    ];
  }
  
}

class ExampleComponent extends Component {

  @prop var title:String;
  @prop var height:Int;

  @update
  public function makeTaller(by:Int) {
    return { height: height + by };
  }

  @update
  public function makeShorter(by:Int) {
    if (height - by <= 150) return null;
    return { height: height - by };
  }

  override function render(context:Context):VNode {
    return Html.div({
      style: ExampleStyle.style({ height: Px(height) }),
      children: [
        Html.h1({ children: [ Html.text(title) ] }),
        Html.button({
          attrs: {
            onclick: e -> {
              e.preventDefault();
              makeTaller(20)
            }
          },
          children: [ Html.text('Taller!') ]
        }),
        Html.button({
          attrs: {
            onclick: e -> {
              e.preventDefault();
              makeShorter(20)
            }
          },
          children: [ Html.text('Shorter!') ]
        })
      ]
    });
  }

}

class Main {

  public static function main() {
    blok.platform.dom.DomPlatform.mount(
      js.Browser.document.getElementById('root'),
      context -> ExampleComponent.node({
        title: 'Hello world',
        height: 150
      })
    );
  }

}

```

> More soon