package blok.style;

import blok.core.VStyle.Value;

abstract Color(Value) to Value {

  public static function rgb(r:Float, g:Float, b:Float):Color {
    return new Color(CallValue('rgb', ListValue([
      SingleValue(r),
      SingleValue(g),
      SingleValue(b)
    ])));
  }
  
  public static function rgba(r:Float, g:Float, b:Float, a:Float):Color {
    return new Color(CallValue('rgba', ListValue([
      SingleValue(r),
      SingleValue(g),
      SingleValue(b),
      SingleValue(a)
    ])));
  }

  public static function hex(value:String) {
    return new Color(SingleValue('#${value}'));
  }

  public static function name(name:String) {
    return new Color(SingleValue(name));
  }

  public inline function new(wrapped:Value) {
    this = wrapped;
  }

  public function withKey(key:String):Color {
    return cast KeyedValue(key, this);
  }

}
