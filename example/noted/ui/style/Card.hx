package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Card extends Style {
  @prop var color:Color = Config.whiteColor;
  @prop var height:CssUnit = null;
  @prop var padding:EdgeInsets = EdgeInsets.all(Config.mediumGap);
  @prop var outlined:Bool = false;

  override function render():StyleExpr {
    return Css.properties([
      
      if (outlined) Css.properties([
        Css.property('color', color),
        Background.export({
          color: Color.name('transparent')
        }),
        Border.export({
          radius: Em(.75),
          width: Px(1),
          type: Solid,
          color: color
        }),
      ]) else Css.properties([
        AutoColor.export({ color: color }),
        Border.export({ 
          type: None,
          width: Px(0),
          radius: Em(.75) 
        }),
        Shadow.export({
          offsetY: None,
          offsetX: None,
          radius: Em(1),
          color: Color.rgba(0, 0, 0, 0.1)
        })
      ]),

      Box.export({
        padding: padding,
        height: height
      })
    ]);
  }
}