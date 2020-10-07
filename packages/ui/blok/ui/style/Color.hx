package blok.ui.style;

import blok.style.VStyle;

@:forward(forIdentifier, toString, getKey)
abstract Color(Value) to Value {
  public static function rgb(r:Float, g:Float, b:Float):Color {
    return new Color(Value.call('rgb', Value.list([ r, g, b ])));
  }
  
  public static function rgba(r:Float, g:Float, b:Float, a:Float):Color {
    return new Color(Value.call('rgba', Value.list([ r, g, b, a ])));
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

  public inline function new(wrapped:Value) {
    this = wrapped;
  }

  public function withKey(key:String):Color {
    return cast Value.keyed(key, this);
  }
}
