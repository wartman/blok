import h2d.Font;
import hxd.App;

using Blok;

class ExampleStyle extends Style {
  @prop var height:Unit;
  @prop var color:Int;
  @prop var backgroundColor:Int = 0xFFCCCCCC;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('padding', 10),
      Style.property('color', color),
      Style.property('background-color', backgroundColor),
      // Style.property('background-color', blok.ui.style.Color.rgba(0, 0, 0, 0.5)),
      blok.ui.style.Box.export({
        height: height
      })
    ];
  }
}

class ExampleTheme implements State {
  @prop var color:Value;
  @prop var font:Font;

  @update
  public function setColor(color:Value) {
    return UpdateState({ color: color });
  }
}

class ExampleComponent extends Component {
  @prop var title:String;
  @prop var height:Int;

  @update
  public function makeTaller(by:Int) {
    return UpdateState({ height: height + by });
  }

  @update
  public function makeShorter(by:Int) {
    if (height - by <= 50) return None;
    return UpdateState({ height: height - by });
  }

  override function render(context:Context):VNode {
    return ExampleTheme.observe(context, state -> Ui.flow({
      props: {
        verticalAlign: Top,
        layout: Horizontal,
        padding: 10,
      },
      // style: ExampleStyle.style({
      //   height: Num(100),
      //   color: 0xFF666666
      // }),
      children: [
        Ui.flow({
          props: {},
          style: ExampleStyle.style({
            height: Num(50),
            color: 0xFF666666,
            backgroundColor: 0xFF666666
          }),
          children: [ Ui.text({
            props: {
              font: state.font,
              text: title
            }
          }) ]
        }),
        Ui.interactive({
          props: {
            height: 100,
            width: 100,
            onClick: e -> makeTaller(10)
          },
          style: ExampleStyle.style({
            height: Num(height),
            color: 0xFFCCCCCC,
            backgroundColor: 0xFF666666
          }),
          children: [
            Ui.flow({
              props: {
                padding: 10,
                layout: Vertical
              },
              children: [
                Ui.text({
                  props: {
                    font: state.font,
                    text: 'More'
                  }
                }),
                Ui.text({
                  props: {
                    font: state.font,
                    text: 'And stuff'
                  }
                }),
              ]
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
      context -> ExampleTheme.provide({
        color: blok.ui.style.Color.hex(0xCCC),
        font: hxd.res.DefaultFont.get()
      }, ctx -> ExampleComponent.node({
        title: 'Foo',
        height: 100
      }))
    );
  }
}
