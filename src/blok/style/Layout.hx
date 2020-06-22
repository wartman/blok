package blok.style;

import blok.core.VStyle;
import blok.core.Style;

enum abstract FlexDirection(ValueDef) to ValueDef {
  var Column = 'column';
  var Row = 'row';
}

class Layout extends Style {

  @prop var direction:FlexDirection;

  override function render():Array<VStyle> {
    return [
      VProperty('display', SingleValue('flex')),
      VProperty('flex-direction', SingleValue(direction))
    ];
  }

}
