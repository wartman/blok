package todo.style;

import blok.ui.style.*;

using Blok;

class Card extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var height:Unit = null;
  @prop var padding:EdgeInsets = EdgeInsets.symmetric(Config.smallGap, Config.mediumGap);

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', switch color.getKey() {
        case 'white' | 'light': Config.darkColor;
        case 'mid' | 'dark': Config.lightColor;
        case _: Config.darkColor; 
      }),
      Background.export({ color: color }),
      Display.export({ kind: Block }),
      Border.export({ 
        type: None,
        width: Px(0),
        radius: Px(5) 
      }),
      Box.export({
        padding: padding,
        height: height
      })
    ];
  }
}
