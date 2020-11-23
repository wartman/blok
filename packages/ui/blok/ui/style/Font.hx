package blok.ui.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssUnit;

enum FontWeight {
  Normal;
  Bold;
  Inherit;
  Initial;
  Unset;
  Custom(value:CssUnit);
}

enum abstract TextAlign(String) to String {
  var Left = "left";
  var Right = "right";
  var Center = "center";
  var Justify = "justify";
  var JustifyAll = "justify-all";
  var Start = "start";
  var End = "end";
  var MatchParent = "match-parent";
  var Inherit = "inherit";
  var Initial = "initial";
  var Unset = "unset";
}

class Font extends Style {
  @prop var family:String = null;
  @prop var size:CssUnit = null;
  @prop var spacing:CssUnit = null;
  @prop var weight:FontWeight = null;
  @prop var color:Color = null;
  @prop var lineHeight:CssUnit = null;
  @prop var align:TextAlign = null;
  // @todo: This class should handle @font-face as well

  override function render():StyleExpr {
    var props:Array<StyleExpr> = [];

    if (family != null) props.push(Css.property('font-family', family));
    if (size != null) props.push(Css.property('font-size', size));
    if (spacing != null) {
      // @todo: this will require some real Math at some point.
      //        something like, very basically: `size + spacing`
      props.push(Css.property('line-height', spacing));
    }
    if (weight != null) props.push(Css.property('font-weight', switch weight {
      case Normal: 'normal';
      case Bold: 'bold';
      case Inherit: 'inherit';
      case Initial: 'initial';
      case Unset: 'unset';
      case Custom(value): value;
    }));
    if (color != null) props.push(Css.property('color', color));
    if (lineHeight != null) props.push(Css.property('line-height', lineHeight));
    if (align != null) props.push(Css.property('text-align', align));

    return Css.properties(props);
  }
}
