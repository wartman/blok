package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Card extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Border.export({
        radius: Em(1)
      }),
      Box.export({
        padding: EdgeInsets.all(Em(1))
      }),
      Background.export({
        color: Color.hex(0xCCCCCC)
      })
    ];
  }
}
