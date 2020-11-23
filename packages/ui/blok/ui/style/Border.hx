package blok.ui.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssUnit;

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
  @prop var radius:CssUnit = null;
  @prop var width:CssUnit = null;
  @prop var color:Color = null;
  @prop var type:BorderType = None;
  @prop var side:BorderSide = All;

  override function render():StyleExpr {
    var props:Array<StyleExpr> = [];

    if (radius != null) props.push(Css.property('border-radius', radius));
    if (width != null) props.push(Css.property('border-width', width));
    if (color != null) props.push(Css.property('border-color', color));
    if (type != null) switch side {
      case null | All: 
        props.push(Css.property('border-style', type));
      case TopBottom: 
        props = props.concat([
          Css.property('border-top-style', type),
          Css.property('border-bottom-style', type),
        ]);
      case LeftRight: 
        props = props.concat([
          Css.property('border-left-style', type),
          Css.property('border-right-style', type),
        ]);
      case s: 
        props.push(Css.property('border-${s}-style', type));
    }

    return Css.properties(props);
  }
}

