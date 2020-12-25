import h2d.Font;
import hxd.App;

using Blok;

class ExampleTheme implements State {
  @prop var color:Int;
  @prop var font:Font;

  @update
  public function setColor(color:Int) {
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
      children: [
        Ui.flow({
          props: {},
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

class TestH2d extends App {
  public static function main() {
    var app = new TestH2d();
  }

  public function new() {
    super();
  }

  override function init() {
    hxd.Res.initEmbed();
    Platform.mount(
      s2d,
      context -> ExampleTheme.provide({
        color: 0xCCC,
        font: hxd.res.DefaultFont.get()
      }, ctx -> ExampleComponent.node({
        title: 'Foo',
        height: 100
      }))
    );
  }
}
