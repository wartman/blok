package todo.style;

import blok.style.*;

using Blok;

class Root extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Style.global(Style.properties([
        Style.child('body', Style.properties([
          Style.property('background-color', Config.darkColor),
          Style.property('margin', EdgeInsets.all(Px(0))),
          Style.property('padding', EdgeInsets.all(Px(0))),
          Font.export({
            family: 'sans-serif',
            size: Px(13),
            color: Config.darkColor
          })
        ]))
      ])),
      Flex.export({
        direction: Row
      }),
      Box.export({
        padding: EdgeInsets.all(Config.mediumGap)
      })
    ];
  }
}
