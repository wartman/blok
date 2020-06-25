package blok.style;

import blok.core.VStyle;
import blok.core.Style;

enum abstract FlexDirection(String) to String {
  var Column = 'column';
  var Row = 'row';
}

class Layout extends Style {

  @prop var direction:FlexDirection;

  override function render():Array<VStyle> {
    return [
      VProperty('display', 'flex'),
      VProperty('flex-direction', direction)
    ];
  }

}
