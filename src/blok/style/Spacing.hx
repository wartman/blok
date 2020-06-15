package blok.style;

import blok.core.VStyle.Unit;
import blok.core.VStyle.Value;

abstract Spacing(Value) to Value {

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
