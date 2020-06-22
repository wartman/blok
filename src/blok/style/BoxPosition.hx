package blok.style;

import blok.core.VStyle;
import blok.core.Style;

enum abstract BoxPositionType(ValueDef) to ValueDef {
  var Absolute = 'absolute';
  var Fixed = 'fixed';
}

class BoxPosition extends Style {

  @prop var type:BoxPositionType;
  @prop var top:Unit = null;
  @prop var bottom:Unit = null;
  @prop var left:Unit = null;
  @prop var right:Unit = null;

  override function render():Array<VStyle> {
    var style = [
      VProperty('position', SingleValue(type))
    ];

    if (top != null) style.push(VProperty('top', SingleValue(top)));
    if (bottom != null) style.push(VProperty('bottom', SingleValue(bottom)));
    if (left != null) style.push(VProperty('left', SingleValue(left)));
    if (right != null) style.push(VProperty('right', SingleValue(right)));

    return style;
  }

}
