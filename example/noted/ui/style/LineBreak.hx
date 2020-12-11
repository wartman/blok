package noted.ui.style;

import blok.core.foundation.style.*;

using Blok;

class LineBreak extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var gap:CssUnit = Config.mediumGap;
  @prop var spacing:CssUnit = Config.mediumGap;

  override function render():StyleExpr {
    return Css.properties([
      Box.export({
        padding: EdgeInsets.bottom(gap),
        margin: EdgeInsets.bottom(spacing),
        borderSide: Bottom,
        borderColor: color,
        borderWidth: Px(1),
        borderStyle: Solid
      })
    ]);
  }
}
