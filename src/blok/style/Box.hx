package blok.style;

import blok.core.Style;
import blok.core.VStyle;

class Box extends Style {
  
  @prop var padding:Spacing = null;
  @prop var margin:Spacing = null;
  @prop var height:Unit = null;
  @prop var width:Unit = null;

  override function render():Array<VStyle> {
    var props:Array<VStyle> = [
      VProperty('display', SingleValue('block'))
    ];
    if (padding != null) props.push(VProperty('padding', padding));
    if (margin != null) props.push(VProperty('margin', margin));
    if (height != null) props.push(VProperty('height', SingleValue(height)));
    if (width != null) props.push(VProperty('width', SingleValue(width)));
    return props;
  }

}
