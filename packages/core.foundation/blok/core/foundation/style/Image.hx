package blok.core.foundation.style;

import blok.core.html.CssValue;

@:forward(toString)
abstract Image(CssValue) to CssValue {
  public static function url(src:String, key:String) {
    return new Image(CssValue.call('url', '"${src}"'));
  }

  public function new(value:CssValue) {
    this = value;
  }
}
