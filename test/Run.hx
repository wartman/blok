import js.Browser;
import blok.Context;
import blok.VNode;
import blok.Component;
import blok.Platform;
import blok.Html;
import blok.State;

class Run {
  static function main() {
    Platform.mount(
      Browser.document.getElementById('root'),
      context -> FooState.provide(context, {
        foo: 'foo'
      }, internalContext -> Html.div({
        attrs: {
          className: 'Foo'
        },
        children: [
          FooState.subscribe(internalContext, state -> TestComp.node({ foo: state.foo })),
          Html.a({
            attrs: { 
              href: 'http://test.com', 
              onclick: e -> e.preventDefault() 
            },
            children: [ Html.text('A link!') ]
          })
        ]
      }))
    );
  }
}

class FooState extends State {
  @prop var foo:String;

  @update
  public function setFoo(foo:String) {
    return { foo: foo };
  }
}

class TestComp extends Component {
  @prop var foo:String;

  override function render(context:Context):VNode {
    var state = FooState.forContext(context);
    return Html.div({
      attrs: { className: 'foo' },
      children: [
        Html.text(foo),
        Html.button({
          attrs: { onclick: _ -> state.setFoo('Bar') },
          children: [ Html.text('Make bar') ]
        })
      ]
    });
  }
}
