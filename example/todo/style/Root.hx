package todo.style;

import blok.ui.style.*;

using Blok;

class Root extends Style {
  override function render():Array<VStyleExpr> {
    return [
      globals(),
      Flex.export({
        direction: Column
      }),
      Box.export({
        padding: EdgeInsets.all(Config.mediumGap),
        width: Px(900)
      }),
      MediaQuery.maxWidth(Px(900), [
        Box.export({
          width: Pct(100)
        })
      ])
    ];
  }

  inline function globals() {
    return Style.global([
      Style.child('#root', [
        Style.property('width', Pct(100)),
        Flex.horizontallyCentered()
      ]),
      Style.child('h1, h2, h3', [
        Font.export({ size: Em(1), weight: Bold }),
        Style.property('padding', Num(0)),
        Style.property('margin', Num(0))
      ]),
      Style.child('body', [
        Style.property('background-color', Config.darkColor),
        Style.property('margin', EdgeInsets.all(Num(0))),
        Style.property('padding', EdgeInsets.all(Num(0))),
        Font.export({
          family: 'sans-serif',
          size: Em(.8),
          color: Config.darkColor
        })
      ])
    ]);
  }
}
