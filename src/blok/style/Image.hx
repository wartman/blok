package blok.style;

import blok.core.VStyle;

abstract Image(Value) to Value {
  
  public static function url(src:String, key:String) {
    return new Image(KeyedValue(key, CallValue('url', SingleValue('"${src}"'))));
  }

  // todo: other options (there are a lot :V)

  public function new(value:Value) {
    this = value;
  }

}
