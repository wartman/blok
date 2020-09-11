package blok.ui.style;

import blok.core.VStyle;
import blok.core.Style;

enum FontWeight {
  Normal;
  Bold;
  Inherit;
  Initial;
  Unset;
  Custom(value:Unit);
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
  @prop var size:Unit = null;
  @prop var spacing:Unit = null;
  @prop var weight:FontWeight = null;
  @prop var color:Color = null;
  @prop var lineHeight:Unit = null;
  @prop var align:TextAlign = null;
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
    if (weight != null) props.push(Style.property('font-weight', switch weight {
      case Normal: 'normal';
      case Bold: 'bold';
      case Inherit: 'inherit';
      case Initial: 'initial';
      case Unset: 'unset';
      case Custom(value): value;
    }));
    if (color != null) props.push(Style.property('color', color));
    if (lineHeight != null) props.push(Style.property('line-height', lineHeight));
    if (align != null) props.push(Style.property('text-align', align));

    return props;
  }
}
