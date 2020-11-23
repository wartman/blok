package blok.ui.style;

import blok.core.style.StyleExpr;
import blok.core.style.Style;
import blok.core.html.Css;
import blok.core.html.CssUnit;

enum abstract PositionType(String) to String {
  var Absolute = 'absolute';
  var Fixed = 'fixed';
  var Relative = 'relative';
}

class Position extends Style {
  @prop var type:PositionType;
  @prop var top:CssUnit = null;
  @prop var bottom:CssUnit = null;
  @prop var left:CssUnit = null;
  @prop var right:CssUnit = null;

  override function render():StyleExpr {
    var props = [
      Css.property('position', type)
    ];

    if (top != null) props.push(Css.property('top', top));
    if (bottom != null) props.push(Css.property('bottom', bottom));
    if (left != null) props.push(Css.property('left', left));
    if (right != null) props.push(Css.property('right', right));

    return Css.properties(props);
  }
}
