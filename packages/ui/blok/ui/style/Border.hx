package blok.ui.style;

import blok.style.VStyle;
import blok.style.Style;

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

enum abstract BorderSide(String) {
  var All = 'all';
  var Bottom = 'bottom';
  var Left = 'left';
  var Right = 'right';
  var Top = 'top';
  var TopBottom = 'top-bottom';
  var LeftRight = 'left-right';
}

class Border extends Style {
  @prop var radius:Unit = null;
  @prop var width:Unit = null;
  @prop var color:Color = null;
  @prop var type:BorderType = None;
  @prop var side:BorderSide = All;

  override function render():Array<VStyleExpr> {
    var props:Array<VStyleExpr> = [];
    if (radius != null) props.push(Style.property('border-radius', radius));
    if (width != null) props.push(Style.property('border-width', width));
    if (color != null) props.push(Style.property('border-color', color));
    if (type != null) switch side {
      case null | All: 
        props.push(Style.property('border-style', type));
      case TopBottom: 
        props = props.concat([
          Style.property('border-top-style', type),
          Style.property('border-bottom-style', type),
        ]);
      case LeftRight: 
        props = props.concat([
          Style.property('border-left-style', type),
          Style.property('border-right-style', type),
        ]);
      case s: 
        props.push(Style.property('border-${s}-style', type));
    }
    return props;
  }
}

