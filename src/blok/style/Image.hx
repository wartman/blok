package blok.style;

import blok.core.VStyle;

@:forward
abstract Image(Value) to Value {
  
  public static function url(src:String, key:String) {
    return new Image(Value.keyed(key, Value.call('url', '"${src}"')));
  }

  // todo: other options (there are a lot :V)

  public function new(value:Value) {
    this = value;
  }

}
