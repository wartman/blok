package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Card extends Style {
  @prop var color:Color = Config.whiteColor;
  @prop var height:Unit = null;
  @prop var padding:EdgeInsets = EdgeInsets.all(Config.mediumGap);
  @prop var outlined:Bool = false;

  override function render():Array<VStyleExpr> {
    return [
      if (outlined) Style.properties([
        Style.property('color', color),
        Background.export({
          color: Color.name('transparent')
        }),
        Border.export({
          radius: Em(.5),
          width: Px(1),
          type: Solid,
          color: color
        }),
      ]) else Style.properties([
        AutoColor.export({ color: color }),
        Border.export({ 
          type: None,
          width: Px(0),
          radius: Em(.5) 
        })
      ]),
      Box.export({
        padding: padding,
        height: height
      })
    ];
  }
}