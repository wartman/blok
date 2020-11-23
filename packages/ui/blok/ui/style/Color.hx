package blok.ui.style;

import blok.core.html.Css;
import blok.core.html.CssValue;

@:forward(toString)
abstract Color(CssValue) to CssValue {
  public static function rgb(r:Float, g:Float, b:Float):Color {
    return new Color(CssValue.call('rgb', CssValue.list([ r, g, b ])));
  }
  
  public static function rgba(r:Float, g:Float, b:Float, a:Float):Color {
    return new Color(CssValue.call('rgba', CssValue.list([ r, g, b, a ])));
  }

  @:from public static function hex(value:Int) {
    return new Color('#${StringTools.hex(value)}');
  }

  @:from public static function name(name:String) {
    return new Color(name);
  }

  public static function inherit() {
    return new Color('inherit');
  }

  public inline function new(wrapped:CssValue) {
    this = wrapped;
  }
}
