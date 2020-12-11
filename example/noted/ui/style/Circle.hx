package noted.ui.style;

import blok.core.foundation.style.*;

using Blok;

class Circle extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var outlined:Bool = false;
  @prop var radius:CssUnit = Em(2);

  override function render():StyleExpr {
    return Css.properties([
      if (outlined) Box.export({
        backgroundColor: Color.name('transparent'),
        borderRadius: Pct(50),
        borderWidth: Px(1),
        borderStyle: Solid,
        borderColor: color,
        contentColor: color
      }) else Css.properties([
        AutoColor.export({ color: color }),
        Box.export({
          borderStyle: None,
          borderWidth: Px(0),
          borderRadius: Pct(50) 
        }),
      ]),
      Box.export({
        padding: EdgeInsets.all(None),
        height: radius,
        width: radius
      }),
      Font.export({
        lineHeight: radius,
        align: Center
      })
    ]);
  }
}
