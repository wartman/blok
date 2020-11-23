package blok.ui.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssUnit;

class Box extends Style {
  @prop var padding:EdgeInsets = null;
  @prop var spacing:EdgeInsets = null;
  @prop var height:CssUnit = null;
  @prop var width:CssUnit = null;
  @prop var minHeight:CssUnit = null;
  @prop var minWidth:CssUnit = null;

  override function render():StyleExpr {
    var props:Array<StyleExpr> = [];
    
    if (padding != null) props.push(Css.property('padding', padding));
    if (height != null) props.push(Css.property('height', height));
    if (width != null) props.push(Css.property('width', width));
    if (minHeight != null) props.push(Css.property('minHeight', minHeight));
    if (minWidth != null) props.push(Css.property('minWidth', minWidth));
    
    if (spacing != null) {
      // this is bleh -- we should be checking for vertical or 
      // horizontal spacing, depending on context.
      props = props.concat([
        Css.property('margin', spacing),
        Css.modifier(':first-child', [
          Css.property('margin-left', CssUnit.None),
          Css.property('margin-top', CssUnit.None)
        ]),
        Css.modifier(':last-child', [
          Css.property('margin-right', CssUnit.None),
          Css.property('margin-bottom', CssUnit.None)
        ])
      ]);
    }

    return Css.properties(props);
  }
}
