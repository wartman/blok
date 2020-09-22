package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Pill extends Style {
  @prop var backgroundColor:Color;

  override function render():Array<VStyleExpr> {
    return [
      Box.export({
        height: Em(2),
        padding: EdgeInsets.symmetric(None, Em(1))
      }),
      Border.export({
        radius: Em(1),
        type: None,
        width: None
      }),
      Background.export({
        color: backgroundColor
      }),
      Font.export({
        lineHeight: Em(2)
      })
    ];
  }
}
