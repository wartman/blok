package blok.ui.style;

import blok.style.Style;
import blok.style.VStyle;

class Shadow extends Style {
  @prop var radius:Unit = null;
  @prop var offsetX:Unit;
  @prop var offsetY:Unit;
  @prop var color:Color = null;

  override function render():Array<VStyleExpr> {
    return [
      Style.property(
        'box-shadow', 
        '${offsetX.toString()} ${offsetY.toString()}'
        + (if (radius != null) ' ' + radius.toString() else '')
        + (if (color != null) ' ' + color.toString() else '')
      )
    ];
  }
}
