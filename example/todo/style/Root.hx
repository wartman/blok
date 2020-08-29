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
      Style.child('body', [
        Style.property('background-color', Config.darkColor),
        Style.property('margin', EdgeInsets.all(Px(0))),
        Style.property('padding', EdgeInsets.all(Px(0))),
        Font.export({
          family: 'sans-serif',
          size: Px(13),
          color: Config.darkColor
        })
      ])
    ]);
  }
}
