import h2d.Font;
import hxd.App;

using Blok;

class ExampleStyle extends Style {
  @prop var height:Unit;
  @prop var color:Value;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', color),
      Style.property('background-color', blok.ui.style.Color.rgba(0, 0, 0, 0.5)),
      blok.ui.style.Box.export({
        height: height
      })
    ];
  }
}

class ExampleTheme extends State {
  @prop var color:Value;
  @prop var font:Font;

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
    if (height - by <= 50) return null;
    return { height: height - by };
  }

  override function render(context:Context):VNode {
    return ExampleTheme.subscribe(context, state -> Ui.flow({
      props: {
        minHeight: height,
        maxHeight: 200
      },
      children: [
        Ui.text({
          props: {
            font: state.font,
            text: title
          }
        }),
        Ui.interactive({
          props: {
            height: height,
            width: 100,
            backgroundColor: 0xFFCCCCCC,
            onClick: e -> makeTaller(10)
          },
          children: [
            Ui.text({
              props: {
                font: state.font,
                text: 'More'
              }
            })
          ]
        }),
        Ui.interactive({
          props: {
            height: height,
            width: 100,
            backgroundColor: 0xFFCCCCCC,
            onClick: e -> makeShorter(10)
          },
          children: [
            Ui.text({
              props: {
                font: state.font,
                text: 'Less'
              }
            })
          ]
        })
      ]
    }));
  }
}

class Run extends App {
  public static function main() {
    var app = new Run();
  }

  public function new() {
    super();
  }

  override function init() {
    hxd.Res.initEmbed();
    Platform.mount(
      s2d,
      context -> ExampleTheme.provide(context, {
        color: blok.ui.style.Color.hex(0xCCC),
        font: hxd.res.DefaultFont.get()
      }, ctx -> ExampleComponent.node({
        title: 'Foo',
        height: 100
      }))
    );
  }
}
