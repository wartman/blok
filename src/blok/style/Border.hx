package blok.style;

import blok.core.VStyle;
import blok.core.Style;

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

  override function render():Array<VStyle> {
    var props:Array<VStyle> = [];
    if (radius != null) props.push(VProperty('border-radius', radius));
    if (width != null) props.push(VProperty('border-width', width));
    if (color != null) props.push(VProperty('border-color', color));
    if (type != null) props.push(VProperty('border-style', type));
    return props;
  }

}
