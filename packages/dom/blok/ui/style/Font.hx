package blok.ui.style;

import blok.core.VStyle;
import blok.core.Style;

class Font extends Style {
  @prop var family:String = null;
  @prop var size:Unit = null;
  @prop var spacing:Unit = null;
  @prop var weight:Int = null;
  @prop var color:Color;
  // @todo: This class should handle @font-face as well

  override function render():Array<VStyleExpr> {
    var props:Array<VStyleExpr> = [];

    if (family != null) props.push(Style.property('font-family', family));
    if (size != null) props.push(Style.property('font-size', size));
    if (spacing != null) {
      // @todo: this will require some real Math at some point.
      //        something like, very basically: `size + spacing`
      props.push(Style.property('line-height', spacing));
    }
    if (weight != null) props.push(Style.property('font-weight', weight));
    if (color != null) props.push(Style.property('color', color));

    return props;
  }
}
