package blok.ui.style;

import blok.core.html.CssUnit;
import blok.core.html.CssValue;

enum abstract RelativePosition(String) to String {
  var Top = 'top';
  var Left = 'left';
  var Bottom = 'bottom';
  var Right = 'right';
  var Center = 'center';
}

@:forward
abstract EdgeOffsets(CssValue) to CssValue {
  public inline static function top() {
    return new EdgeOffsets(RelativePosition.Top);
  }

  public inline static function right() {
    return new EdgeOffsets(RelativePosition.Right);
  }

  public inline static function bottom() {
    return new EdgeOffsets(RelativePosition.Bottom);
  }
  
  public inline static function left() {
    return new EdgeOffsets(RelativePosition.Left);
  }

  // @todo: allow RelativePosition as a value here:
  public inline static function symmetric(vertical:CssUnit, horizontal:CssUnit) {
    return new EdgeOffsets(CssValue.compound([ vertical, horizontal ]));
  }

  // @todo: allow RelativePosition as a value here:
  public static function define(props:{
    ?top:CssUnit,
    ?right:CssUnit,
    ?bottom:CssUnit,
    ?left:CssUnit
  }) {
    return new EdgeOffsets(CssValue.compound([
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
