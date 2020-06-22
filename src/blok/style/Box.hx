package blok.style;

import blok.core.Style;
import blok.core.VStyle;

class Box extends Style {
  
  @prop var padding:EdgeInsets = null;
  // @prop var margin:EdgeInsets = null;
  @prop var spacing:EdgeInsets = null;
  @prop var height:Unit = null;
  @prop var width:Unit = null;

  override function render():Array<VStyle> {
    var props:Array<VStyle> = [
      VProperty('display', SingleValue('block'))
    ];
    
    if (padding != null) props.push(VProperty('padding', padding));
    // if (margin != null) props.push(VProperty('margin', margin));
    if (height != null) props.push(VProperty('height', SingleValue(height)));
    if (width != null) props.push(VProperty('width', SingleValue(width)));
    
    if (spacing != null) {
      // this is bleh -- we should be checking for vertical or 
      // horizontal spacing, depending on context.
      props = props.concat([
        VProperty('margin', spacing),
        VPsuedo(FirstChild, [
          VProperty('margin-left', SingleValue(Unit.None)),
          VProperty('margin-top', SingleValue(Unit.None))
        ]),
        VPsuedo(LastChild, [
          VProperty('margin-right', SingleValue(Unit.None)),
          VProperty('margin-bottom', SingleValue(Unit.None))
        ])
      ]);
    }

    return props;
  }

}
