package blok.ui.style;

import blok.style.Style;
import blok.style.VStyle;

enum abstract PositionType(String) to String {
  var Absolute = 'absolute';
  var Fixed = 'fixed';
  var Relative = 'relative';
}

class Position extends Style {
  @prop var type:PositionType;
  @prop var top:Unit = null;
  @prop var bottom:Unit = null;
  @prop var left:Unit = null;
  @prop var right:Unit = null;

  override function render():Array<VStyleExpr> {
    var style = [
      Style.property('position', type)
    ];

    if (top != null) style.push(Style.property('top', top));
    if (bottom != null) style.push(Style.property('bottom', bottom));
    if (left != null) style.push(Style.property('left', left));
    if (right != null) style.push(Style.property('right', right));

    return style;
  }
}
