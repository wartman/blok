package noted.ui.style;

import blok.core.foundation.style.*;

using Blok;

class Card extends Style {
  @prop var color:Color = Config.whiteColor;
  @prop var height:CssUnit = null;
  @prop var padding:EdgeInsets = EdgeInsets.all(Config.mediumGap);
  @prop var outlined:Bool = false;

  override function render():StyleExpr {
    return Css.properties([
      if (outlined) Box.export({
        backgroundColor: Color.name('transparent'),
        borderRadius: Em(.75),
        borderWidth: Px(1),
        borderStyle: Solid,
        borderColor: color
      }) else Css.properties([
        AutoColor.export({ color: color }),
        Box.export({ 
          borderStyle: None,
          borderWidth: Px(0),
          borderRadius: Em(.75) 
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