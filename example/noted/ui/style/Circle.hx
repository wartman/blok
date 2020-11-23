package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Circle extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var outlined:Bool = false;
  @prop var radius:CssUnit = Em(2);

  override function render():StyleExpr {
    return Css.properties([
      if (outlined) Css.properties([
        Background.export({
          color: Color.name('transparent')
        }),
        Border.export({
          radius: Pct(50),
          width: Px(1),
          type: Solid,
          color: color
        }),
        Css.property('color', color)
      ]) else Css.properties([
        AutoColor.export({ color: color }),
        Border.export({
          type: None,
          width: Px(0),
          radius: Pct(50) 
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
