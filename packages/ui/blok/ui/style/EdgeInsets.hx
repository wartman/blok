package blok.ui.style;

import blok.style.VStyle.Unit;
import blok.style.VStyle.Value;

@:forward
abstract EdgeInsets(Value) to Value {
  public inline static function top(top:Unit) {
    return define({ top: top });
  }

  public inline static function bottom(bottom:Unit) {
    return define({ bottom: bottom });
  }

  public inline static function left(left:Unit) {
    return define({ left: left });
  }

  public inline static function right(right:Unit) {
    return define({ right: right });
  }

  public inline static function symmetric(vertical:Unit, horizontal:Unit) {
    return define({
      top: vertical,
      bottom: vertical,
      left: horizontal,
      right: horizontal
    });
  }

  public inline static function all(size:Unit) {
    return define({
      top: size,
      right: size,
      bottom: size,
      left: size
    });
  }

  public inline static function define(props:{
    ?top:Unit,
    ?right:Unit,
    ?bottom:Unit,
    ?left:Unit
  }) {
    return new EdgeInsets(Value.compound([
      props.top != null ? props.top : 0,
      props.right != null ? props.right : 0,
      props.bottom != null ? props.bottom : 0,
      props.left != null ? props.left : 0,
    ]));
  }

  inline public function new(value:Value) {
    this = value;
  }
}
