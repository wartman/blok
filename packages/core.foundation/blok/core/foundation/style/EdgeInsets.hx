package blok.core.foundation.style;

import blok.core.html.CssUnit;
import blok.core.html.CssValue;

@:forward(toString)
abstract EdgeInsets(CssValue) to CssValue {
  public inline static function top(top:CssUnit) {
    return define({ top: top });
  }

  public inline static function bottom(bottom:CssUnit) {
    return define({ bottom: bottom });
  }

  public inline static function left(left:CssUnit) {
    return define({ left: left });
  }

  public inline static function right(right:CssUnit) {
    return define({ right: right });
  }

  public inline static function symmetric(vertical:CssUnit, horizontal:CssUnit) {
    return define({
      top: vertical,
      bottom: vertical,
      left: horizontal,
      right: horizontal
    });
  }

  public inline static function all(size:CssUnit) {
    return define({
      top: size,
      right: size,
      bottom: size,
      left: size
    });
  }

  public inline static function define(props:{
    ?top:CssUnit,
    ?right:CssUnit,
    ?bottom:CssUnit,
    ?left:CssUnit
  }) {
    return new EdgeInsets(CssValue.compound([
      props.top != null ? props.top : 0,
      props.right != null ? props.right : 0,
      props.bottom != null ? props.bottom : 0,
      props.left != null ? props.left : 0,
    ]));
  }

  inline public function new(value:CssValue) {
    this = value;
  }
}
