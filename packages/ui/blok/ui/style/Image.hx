package blok.ui.style;

import blok.style.VStyle;

// Todo: this is perhaps too focused on CSS?
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
