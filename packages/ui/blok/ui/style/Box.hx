package blok.ui.style;

import blok.style.Style;
import blok.style.VStyle;

class Box extends Style {
  @prop var padding:EdgeInsets = null;
  @prop var spacing:EdgeInsets = null;
  @prop var height:Unit = null;
  @prop var width:Unit = null;
  @prop var minHeight:Unit = null;
  @prop var minWidth:Unit = null;

  override function render():Array<VStyleExpr> {
    var props:Array<VStyleExpr> = [];
    
    if (padding != null) props.push(Style.property('padding', padding));
    if (height != null) props.push(Style.property('height', height));
    if (width != null) props.push(Style.property('width', width));
    if (minHeight != null) props.push(Style.property('minHeight', minHeight));
    if (minWidth != null) props.push(Style.property('minWidth', minWidth));
    
    if (spacing != null) {
      // this is bleh -- we should be checking for vertical or 
      // horizontal spacing, depending on context.
      props = props.concat([
        Style.property('margin', spacing),
        Style.modifier(':first-child', [
          Style.property('margin-left', Unit.None),
          Style.property('margin-top', Unit.None)
        ]),
        Style.modifier(':last-child', [
          Style.property('margin-right', Unit.None),
          Style.property('margin-bottom', Unit.None)
        ])
      ]);
    }

    return props;
  }
}
