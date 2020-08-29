package todo.style;

import blok.ui.style.*;

using Blok;

class Card extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var height:Unit = null;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', if (color.getName() == Config.lightColor.getName()) {
        Config.darkColor;
      } else {
        Config.lightColor;
      }),
      Background.export({ color: color }),
      Display.export({ kind: Block }),
      Border.export({ radius: Px(5) }),
      Box.export({
        padding: EdgeInsets.symmetric(Config.smallGap, Config.mediumGap),
        height: height
      })
    ];
  }
}
