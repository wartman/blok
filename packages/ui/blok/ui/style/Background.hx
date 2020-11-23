package blok.ui.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssValue;
import blok.core.html.CssUnit;

enum abstract BackgroundAttachment(String) to String {
  var Scroll = 'scroll';
  var Fixed = 'fixed';
  var Local = 'local';
  var Inherit = 'inherit';
  var Initial = 'initial';
  var Unset = 'unset';
}

@:forward
abstract BackgroundSize(CssValue) to CssValue {
  public static function auto() {
    return new BackgroundSize('auto');
  }

  public static function cover() {
    return new BackgroundSize('cover');
  }

  public static function contain() {
    return new BackgroundSize('contain');
  }

  public static function custom(width:CssUnit, height:CssUnit) {
    var value = CssValue.compound([ width, height ]);
    return new BackgroundSize(value);
  }

  public static function multiple(sizes:Array<BackgroundSize>) {
    return new BackgroundSize(CssValue.list(sizes));
  }

  inline public function new(value:CssValue) {
    this = value;
  }
}

class Background extends Style {
  @prop var color:Color = null;
  @prop var image:Image = null;
  @prop var size:BackgroundSize = null;
  @prop var attachment:BackgroundAttachment = null;
  @prop var position:EdgeOffsets = null;

  override function render():StyleExpr {
    var style:Array<StyleExpr> = [];

    if (color != null) style.push(Css.property('background-color', color));
    if (image != null) style.push(Css.property('background-image', image));
    if (size != null) style.push(Css.property('background-size', size));
    if (position != null) style.push(Css.property('background-position', position));
    if (attachment != null) style.push(Css.property('background-attachment', attachment));

    return Css.properties(style);
  }
}
