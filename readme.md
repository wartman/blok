Blok
====

Building blocks for UI

About
-----

Blok is a UI framework for Haxe designed to be simple and free of dependencies or DSLs. Everything is written in normal Haxe, with just a little macro magic to make things simpler.

Packages
--------

Packages will be split out eventually, but they're all in one place for now (for ease of development and because I'm not sure what works best yet).

- blok-core: The base implementation used everywhere.
- blok-dom: Implementation for browsers, plus HTML implementation.
- blok-static: Static HTML rendering?
- blok-h2d: Implementation for heaps, plus implementations for most h2d classes.

Example
-------

> Note: things are changing fast, this may be out of date.

```haxe
using Blok;

class ExampleStyle extends Style {
  @prop var height:Unit;
  @prop var color:Value;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', color),
      Style.property('background-color', blok.style.Color.rgba(0, 0, 0, 0.5)),
      blok.style.Box.export({
        height: height
      })
    ];
  }
}

class ExampleTheme implements State {
  @prop var color:Value;

  @update
  public function setColor(color:Value) {
    return { color: color };
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
    return ExampleTheme.subscribe(context, state ->
      Html.div({
        style: ExampleStyle.style({ color: state.color,  height: Px(height) }),
        children: [
          Html.h1({ children: [ Html.text(title) ] }),
          Html.button({
            attrs: {
              onclick: e -> {
                e.preventDefault();
                makeTaller(20);
              }
            },
            children: [ Html.text('Taller!') ]
          }),
          Html.button({
            attrs: {
              onclick: e -> {
                e.preventDefault();
                makeShorter(20);
              }
            },
            children: [ Html.text('Shorter!') ]
          })
        ]
      })
    );
  }
}

class Run {

  public static function main() {
    Platform.mount(
      js.Browser.document.getElementById('root'),
      _ -> ExampleTheme.provide({
        color: blok.style.Color.hex(0xCCC)
      }, ctx -> Html.fragment([
        ExampleComponent.node({
          title: 'Hello world',
          height: 150
        }),
        Html.button({
          attrs: {
            onclick: _ -> ExampleTheme
              .from(ctx)
              .setColor(blok.style.Color.hex(0x666))
          },
          children: [ Html.text('Swap color') ]
        })
      ]))
    );
  }

}

```

Observables
-----------

Blok uses simple `Observables` to handle state. Here's an example:

```haxe
using Blok;

class Example extends Component {
  final foo = new ObservableValue('foo');

  override function render(context:Context):VNode {
    return Html.div({
      children: [
        Html.button({
          attrs: {
            onclick: _ -> foo.notify('bar')
          },
          children: [ Html.text('Make bar') ]
        }),
        ObservableSubscriber.subscribe(foo, value -> Html.text(value))
      ]
    });
  }
}

```

In this case, you'd probably just use `@update` methods instead, but you get the principal.

> todo: explain ObservableProvider here, and how it's handy to provide
> state across an app.

Where this becomes more useful is with `blok.State`, which builds on top of `blok.core.Observable<T>`.

```haxe
using Blok;

class FooState implements State {
  @prop var foo:String;

  @update
  public function setFoo(foo) {
    return { foo: foo };
  }
}
```

States are generally useful to provide state that's shared between components.

> todo

> More soon
