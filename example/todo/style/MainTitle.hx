package todo.style;

import blok.ui.style.*;

using Blok;

class MainTitle extends Style {
  override function render():Array<VStyleExpr> {
    return [
      // Box.export({
      //   padding: EdgeInsets.bottom(Em(1))
      // }),
      Font.export({
        weight: Bold,
        size: Em(2),
        lineHeight: Em(2)
      })
    ];
  }
}
