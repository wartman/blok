package blok.ui.framework;

import blok.style.Style;
import blok.style.VStyle;

enum abstract AlignmentPosition(String) {
  var Left;
  var Right;
}

class Align extends Style {
  @prop var position:AlignmentPosition;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('margin-left', switch position {
        case Left: 'auto';
        case Right: '0';
      })
    ];
  }
}
