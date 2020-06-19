package blok.style;

import blok.core.VStyle;

abstract Image(Value) to Value {
  
  public static function src(src:String, key:String) {
    return new Image(KeyedValue(key, CallValue('img', SingleValue('"${src}"'))));
  }

  public function new(value:Value) {
    this = value;
  }

}
