package blok.ui.style;

import blok.core.html.CssValue;

@:forward
abstract Image(CssValue) to CssValue {
  public static function url(src:String, key:String) {
    return new Image(CssValue.call('url', '"${src}"'));
  }

  // todo: other options (there are a lot :V)

  public function new(value:CssValue) {
    this = value;
  }
}
