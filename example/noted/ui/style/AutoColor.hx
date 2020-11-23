package noted.ui.style;

import blok.ui.style.Color;
import blok.ui.style.Background;

using Blok;

class AutoColor extends Style {
  @prop var color:Color;

  override function render():StyleExpr {
    return Css.properties([
      Css.property('color', 
        if (color == Config.lightColor || color == Config.whiteColor) Config.darkColor
        else if (color == Config.midColor || color == Config.darkColor) Config.lightColor
        else if (color == Config.errorColor) Config.whiteColor
        else Config.darkColor
      ),
      Background.export({ color: color }),
      Css.modifier(':disabled', [
        Css.property('color',
          if (color == Config.whiteColor || color == Config.lightColor) Config.midColor
          else if (color == Config.midColor || color == Config.darkColor) Config.lightColor
          else Config.midColor
        ),
        Background.export({ color:
          if (color == Config.whiteColor || color == Config.lightColor) color
          else if (color == Config.darkColor) Config.midColor
          else color
        }),
      ])
    ]);
  }
}
