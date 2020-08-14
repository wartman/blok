package blok.style;

import blok.internal.VStyle;
import blok.internal.Style;

enum abstract BorderType(String) to String {
  var None = 'none';
  var Solid = 'solid';
  var Hidden = 'hidden';
  var Dotted = 'dotted';
  var Dashed = 'dashed';
  var Double = 'double';
  var Groove = 'groove';
  var Ridge = 'ridge';
  var Inset = 'inset';
  var Outset = 'outset';
}

class Border extends Style {
  @prop var radius:Unit = null;
  @prop var width:Unit = null;
  @prop var color:Color = null;
  @prop var type:BorderType = None;

  override function render():Array<VStyleExpr> {
    var props:Array<VStyleExpr> = [];
    if (radius != null) props.push(Style.property('border-radius', radius));
    if (width != null) props.push(Style.property('border-width', width));
    if (color != null) props.push(Style.property('border-color', color));
    if (type != null) props.push(Style.property('border-style', type));
    return props;
  }
}

