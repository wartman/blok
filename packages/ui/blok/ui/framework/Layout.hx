package blok.ui.framework;

import blok.style.Style;
import blok.style.VStyle;

enum abstract LayoutDirection(String) to String {
  var Column = 'column';
  var Row = 'row';
}

class Layout extends Style {
  @prop var direction:LayoutDirection = Row;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('display', 'flex'),
      Style.property('flex-direction', direction)
    ];
  }
}
