package todo.style;

import blok.ui.style.*;

using Blok;

class Card extends Style {
  @prop var color:Color = Config.lightColor;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', if (color.getName() == Config.lightColor.getName()) {
        Config.darkColor;
      } else {
        Config.lightColor;
      }),
      Style.property('background-color', color),
      Box.export({
        padding: EdgeInsets.symmetric(Config.smallGap, Config.mediumGap)
      }),
      Border.export({
        radius: Px(5)
      })
    ];
  }
}
