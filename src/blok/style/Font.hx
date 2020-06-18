package blok.style;

import blok.core.VStyle;
import blok.core.Style;

class Font extends Style {
  
  @prop var family:String = null;
  @prop var size:Unit = null;
  @prop var spacing:Unit = null;
  @prop var weight:Int = null;
  @prop var color:Color;
  // @todo: This class should handle @font-face as well

  override function render():Array<VStyle> {
    var props:Array<VStyle> = [];

    if (family != null) props.push(VProperty('font-family', SingleValue(family)));
    if (size != null) props.push(VProperty('font-size', SingleValue(size)));
    if (spacing != null) {
      // @todo: this will require some real Math at some point.
      //        something like, very basically: `size + spacing`
      props.push(VProperty('line-height', SingleValue(spacing)));
    }
    if (weight != null) props.push(VProperty('font-weight', SingleValue(weight)));
    if (color != null) props.push(VProperty('color', color));

    return props;
  }

}
