package noted.ui.style;

import blok.core.foundation.style.*;
using Blok;

class Selectable extends Style {
  @prop var color:Color = Config.scrimColor;

  override function render():StyleExpr {
    return Pseudo.wrap(Focus, [
      Shadow.export({
        radius: Em(.15),
        blurRadius: None,
        color: color,
        offsetY: None,
        offsetX: None
      })
      // Css.property('outline', CssValue.compound([ Px(1), 'dashed', Config.midColor ]))
    ]);
  }
}
