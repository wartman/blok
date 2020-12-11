package blok.core.foundation.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssUnit;
import blok.core.html.CssValue;

enum abstract BoxDisplay(String) to String {
  var Block = 'block';
  var Inline = 'inline';
  var Table = 'table';
  var Flex = 'flex';
  var Grid = 'grid';
  var Inherit = 'inherit';
  var Initial = 'initial';
  var Unset = 'unset';
  var None = 'none';
  // var Flow = 'flow';
  // var FlowRoot = 'flow-root';
}

enum abstract BoxBorderStyle(String) to String {
  var None = 'none';
  var Solid = 'solid';
  var Hidden = 'hidden';
  var Dotted = 'dotted';
  var Dashed = 'dashed';
  var Double = 'double';
  var Groove = 'groove';
  var Ridge = 'ridge';
  var Inset = 'inset';
  var Outset = 'outset';
}

enum abstract BoxBorderSide(String) {
  var All = 'all';
  var Bottom = 'bottom';
  var Left = 'left';
  var Right = 'right';
  var Top = 'top';
  var TopBottom = 'top-bottom';
  var LeftRight = 'left-right';
}

enum abstract BoxBackgroundAttachment(String) to String {
  var Scroll = 'scroll';
  var Fixed = 'fixed';
  var Local = 'local';
  var Inherit = 'inherit';
  var Initial = 'initial';
  var Unset = 'unset';
}

abstract BoxBackgroundSize(CssValue) to CssValue {
  public static function auto() {
    return new BoxBackgroundSize('auto');
  }

  public static function cover() {
    return new BoxBackgroundSize('cover');
  }

  public static function contain() {
    return new BoxBackgroundSize('contain');
  }

  public static function custom(width:CssUnit, height:CssUnit) {
    var value = CssValue.compound([ width, height ]);
    return new BoxBackgroundSize(value);
  }

  public static function multiple(sizes:Array<BoxBackgroundSize>) {
    return new BoxBackgroundSize(CssValue.list(sizes));
  }

  inline public function new(value:CssValue) {
    this = value;
  }
}

/**
  Describe a box's background, borders, dimensions, etc.
**/
class Box extends Style {
  @prop var display:BoxDisplay = null;
  @prop var padding:EdgeInsets = null;
  @prop var margin:EdgeInsets = null;
  @prop var width:CssUnit = null;
  @prop var height:CssUnit = null;
  @prop var minHeight:CssUnit = null;
  @prop var minWidth:CssUnit = null;
  @prop var contentColor:Color = null;
  @prop var backgroundColor:Color = null;
  @prop var backgroundImage:Image = null;
  @prop var backgroundSize:BoxBackgroundSize = null;
  @prop var backgroundAttachment:BoxBackgroundAttachment = null;
  @prop var backgroundPosition:EdgeOffsets = null;
  @prop var borderRadius:CssUnit = null;
  @prop var borderStyle:BoxBorderStyle = null;
  @prop var borderSide:BoxBorderSide = null;
  @prop var borderWidth:CssUnit = null;
  @prop var borderColor:Color = null;

  override function render():StyleExpr {
    var props:Array<StyleExpr> = [];

    if (display != null) props.push(Css.property('display', display));
    if (padding != null) props.push(Css.property('padding', padding));
    if (margin != null) props.push(Css.property('margin', margin));
    if (height != null) props.push(Css.property('height', height));
    if (width != null) props.push(Css.property('width', width));
    if (minHeight != null) props.push(Css.property('minHeight', minHeight));
    if (minWidth != null) props.push(Css.property('minWidth', minWidth));
    if (contentColor != null) props.push(Css.property('color', contentColor));
    if (backgroundColor != null) props.push(Css.property('background-color', backgroundColor));
    if (backgroundImage != null) props.push(Css.property('background-image', backgroundImage));
    if (backgroundSize != null) props.push(Css.property('background-size', backgroundSize));
    if (backgroundPosition != null) props.push(Css.property('background-position', backgroundPosition));
    if (backgroundAttachment != null) props.push(Css.property('background-attachment', backgroundAttachment));
    if (borderRadius != null) props.push(Css.property('border-radius', borderRadius));
    if (borderWidth != null) props.push(Css.property('border-width', borderWidth));
    if (borderColor != null) props.push(Css.property('border-color', borderColor));
    if (borderStyle != null) switch borderSide {
      case null | All: 
        props.push(Css.property('border-style', borderStyle));
      case TopBottom: 
        props = props.concat([
          Css.property('border-top-style', borderStyle),
          Css.property('border-bottom-style', borderStyle),
        ]);
      case LeftRight: 
        props = props.concat([
          Css.property('border-left-style', borderStyle),
          Css.property('border-right-style', borderStyle),
        ]);
      case s: 
        props.push(Css.property('border-${s}-style', borderStyle));
    }

    return Css.properties(props);
  }
}