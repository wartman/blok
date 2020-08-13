package blok.style;

import blok.internal.Style;
import blok.internal.VStyle;

class Box extends Style {
   
  @prop var padding:EdgeInsets = null;
  @prop var spacing:EdgeInsets = null;
  @prop var height:Unit = null;
  @prop var width:Unit = null;

  override function render():Array<VStyleExpr> {
    var props:Array<VStyleExpr> = [
      Style.property('display', 'block')
    ];
    
    if (padding != null) props.push(Style.property('padding', padding));
    if (height != null) props.push(Style.property('height', height));
    if (width != null) props.push(Style.property('width', width));
    
    if (spacing != null) {
      // this is bleh -- we should be checking for vertical or 
      // horizontal spacing, depending on context.
      props = props.concat([
        Style.property('margin', spacing),
        Style.modifierScope(':first-child', Style.properties([
          Style.property('margin-left', Unit.None),
          Style.property('margin-top', Unit.None)
        ])),
        Style.modifierScope(':last-child', Style.properties([
          Style.property('margin-right', Unit.None),
          Style.property('margin-bottom', Unit.None)
        ]))
      ]);
    }

    return props;
  }

}
