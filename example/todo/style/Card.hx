package todo.style;

import blok.style.*;

using Blok;

class Card extends Style {
  @prop var color:Color = Config.lightColor;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', color),
      Box.export({
        padding: EdgeInsets.symmetric(Px(10), Px(20))
      }),
      Border.export({
        width: Px(2),
        type: Solid,
        color: color
      })
    ];
  }
}
