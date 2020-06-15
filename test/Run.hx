import blok.style.Background;
import blok.core.VStyle;
import blok.style.Color;
import blok.style.Spacing;
import blok.style.Border;
import blok.platform.dom.DomPlatform;

using Blok;

class Run {
  
  static function main() {
    DomPlatform.mount(
      js.Browser.document.getElementById('root'),
      context -> SimpleState.provide(context, {
        foo: ' provided'
      }, state -> Html.div({
        attrs: {
          className: 'foob'
        },
        style: [
          blok.style.Box.style({ padding: Spacing.all(Px(20)) })
        ],
        children: [
          Html.p({ 
            style: blok.style.Box.style({ margin: new Spacing({ bottom: Px(20) }) }),
            children: [ Html.text('foo') ]  
          }),
          Test.node({ foo: 'This is a component' }),
          Html.button({
            attrs: {
              onclick: e -> {
                state.setFoo(' changed');
              }
            },
            children: [ Html.text('Change state') ]
          })
        ]
      }))
    );
  }

}

class Core {

  public static function box(props:{ children:Array<VNode> }) {
    return Html.div({
      style: [
        blok.style.Box.style({ width: Px(150), padding: Spacing.all(Px(20)) })
      ],
      children: props.children
    });
  }

}

class DarkBox extends Style {

  public inline static function defaults() {
    return DarkBox.style({ height: Px(150) }, 'default');
  }

  @prop var height:Unit = null;

  override function render():Array<VStyle> {
    return [
      blok.style.Box.export({
        height: height,
        padding: Spacing.all(Px(20))
      }),
      Border.export({ radius: Px(30) }),
      Background.export({ color: Color.rgb(0, 0, 0) }),
      VProperty('color', Color.rgb(255, 255, 255)),
      blok.style.Box.exportAsChild('span', {
        padding: Spacing.all(Px(10))
      }),
      VChild('span', [
        VProperty('color', Color.hex('666')),
        blok.style.Box.export({
          margin: Spacing.all(Px(10))
        })
      ])
    ];
  }

}

class Box extends Component {

  @prop var children:Array<VNode>;

  override function render(context:Context):VNode {
    return Html.div({
      style: [
        DarkBox.defaults()
      ],
      children: children
    });
  }

}

class Test extends Component {

  @prop var foo:String;

  @update
  public function setFoo(foo:String) {
    if (this.foo == foo) {
      trace('Already changed');
      return null;
    }
    return { foo: foo };
  }

  override function render(context:Context) {
    return SimpleState.consume(context, state -> Box.node({
      children: [
        Html.span({ children: [ Html.text(foo + state.foo) ] }),
        Html.span({ children: [ Html.text('wtf') ] }),
        if (foo != 'updated')
          button('update self', e -> {
            e.preventDefault();
            setFoo('updated');
          })
        else
          button('change', e -> {
            e.preventDefault();
            setFoo('changed');
          })
      ]
    }));
  }

  function button(label, event) {
    return Html.button({
      style: [
        Border.style({ radius: Pct(50) }),
        blok.style.Box.style({ height: Px(30) })
      ],
      attrs: {
        onclick: event
      },
      children: [ Html.text(label) ]
    });
  }

}

class SimpleState extends State {

  @prop var foo:String;

  @update
  public function setFoo(foo:String) {
    if (this.foo == foo) return null;
    return { foo: foo };
  }

}
