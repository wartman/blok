package blok.core.foundation.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssUnit;

class Shadow extends Style {
  @prop var radius:CssUnit = null;
  @prop var offsetX:CssUnit;
  @prop var offsetY:CssUnit;
  @prop var blurRadius:CssUnit = null;
  @prop var color:Color = null;

  override function render():StyleExpr {
    return Css.properties([
      Css.property(
        'box-shadow', 
        '${offsetX.toString()} ${offsetY.toString()}'
        + (if (blurRadius != null) ' ' + blurRadius.toString() else '')
        + (if (radius != null) ' ' + radius.toString() else if (blurRadius != null) '0' else '')
        + (if (color != null) ' ' + color.toString() else '')
      )
    ]);
  }
}
