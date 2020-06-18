package blok.style;

import blok.core.VStyle.Unit;
import blok.core.VStyle.Value;

abstract EdgeInsets(Value) to Value {

  public inline static function top(top:Unit) {
    return new EdgeInsets({ top: top });
  }

  public inline static function bottom(bottom:Unit) {
    return new EdgeInsets({ bottom: bottom });
  }

  public inline static function left(left:Unit) {
    return new EdgeInsets({ left: left });
  }

  public inline static function right(right:Unit) {
    return new EdgeInsets({ right: right });
  }

  public inline static function symmetric(vertical:Unit, horizontal:Unit) {
    return new EdgeInsets({
      top: vertical,
      bottom: vertical,
      left: horizontal,
      right: horizontal
    });
  }

  public inline static function all(size:Unit) {
    return new EdgeInsets({
      top: size,
      right: size,
      bottom: size,
      left: size
    });
  }

  public inline function new(props:{
    ?top:Unit,
    ?right:Unit,
    ?bottom:Unit,
    ?left:Unit
  }) {
    this = CompoundValue([
      SingleValue(props.top != null ? props.top : 0),
      SingleValue(props.right != null ? props.right : 0),
      SingleValue(props.bottom != null ? props.bottom : 0),
      SingleValue(props.left != null ? props.left : 0),
    ]);
  }

}
