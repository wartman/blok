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

class ExampleTheme extends State {
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
      context -> ExampleTheme.provide(context, {
        color: blok.style.Color.hex(0xCCC)
      }, ctx -> Html.fragment([
        ExampleComponent.node({
          title: 'Hello world',
          height: 150
        }),
        Html.button({
          attrs: {
            onclick: _ -> ExampleTheme
              .forContext(ctx)
              .setColor(blok.style.Color.hex(0x666))
          },
          children: [ Html.text('Swap color') ]
        })
      ]))
    );
  }

}