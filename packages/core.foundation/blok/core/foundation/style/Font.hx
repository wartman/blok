package blok.core.foundation.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssUnit;
import blok.core.html.CssValue;

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
  @prop var family:Array<String> = null;
  @prop var size:CssUnit = null;
  @prop var weight:FontWeight = null;
  @prop var color:Color = null;
  @prop var lineHeight:CssUnit = null;
  @prop var align:TextAlign = null;
  // @todo: This class should handle @font-face as well?

  override function render():StyleExpr {
    var props:Array<StyleExpr> = [];

    if (family != null) props.push(Css.property('font-family', CssValue.list(family.map(f -> CssValueSingle(f)))));
    if (size != null) props.push(Css.property('font-size', size));
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
