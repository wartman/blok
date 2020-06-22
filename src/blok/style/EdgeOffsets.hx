package blok.style;

import blok.core.VStyle;

enum abstract RelativePosition(String) to String to ValueDef {
  var Top = 'top';
  var Left = 'left';
  var Bottom = 'bottom';
  var Right = 'right';
  var Center = 'center';
}

abstract EdgeOffsets(Value) to Value {
  
  public inline static function top() {
    return new EdgeOffsets(SingleValue(RelativePosition.Top));
  }

  public inline static function right() {
    return new EdgeOffsets(SingleValue(RelativePosition.Right));
  }

  public inline static function bottom() {
    return new EdgeOffsets(SingleValue(RelativePosition.Bottom));
  }
  
  public inline static function left() {
    return new EdgeOffsets(SingleValue(RelativePosition.Left));
  }

  // @todo: allow RelativePosition as a value here:
  public inline static function symmetric(vertical:Unit, horizontal:Unit) {
    return new EdgeOffsets(CompoundValue([
      SingleValue(vertical),
      SingleValue(horizontal)
    ]));
  }

  // @todo: allow RelativePosition as a value here:
  public static function define(props:{
    ?top:Unit,
    ?right:Unit,
    ?bottom:Unit,
    ?left:Unit
  }) {
    return new EdgeOffsets(CompoundValue([
      SingleValue(props.top != null ? props.top : 0),
      SingleValue(props.right != null ? props.right : 0),
      SingleValue(props.bottom != null ? props.bottom : 0),
      SingleValue(props.left != null ? props.left : 0),
    ]));
  }

  inline public function new(value:Value) {
    this = value;
  }

}