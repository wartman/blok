package blok.style;

import blok.core.VStyle.Unit;
import blok.core.VStyle.Value;

abstract Spacing(Value) to Value {

  public inline static function top(top:Unit) {
    return new Spacing({ top: top });
  }

  public inline static function bottom(bottom:Unit) {
    return new Spacing({ bottom: bottom });
  }

  public inline static function left(left:Unit) {
    return new Spacing({ left: left });
  }

  public inline static function right(right:Unit) {
    return new Spacing({ right: right });
  }

  public inline static function sides(topBottom:Unit, leftRight:Unit) {
    return new Spacing({
      top: topBottom,
      bottom: topBottom,
      left: leftRight,
      right: leftRight
    });
  }

  public inline static function all(unit:Unit) {
    return new Spacing({
      top: unit,
      right: unit,
      bottom: unit,
      left: unit
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
