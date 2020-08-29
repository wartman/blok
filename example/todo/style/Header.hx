package todo.style;

import blok.ui.style.Font;

using Blok;

class Header extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Style.property('height', Em(2)),
      Style.property('line-height', Em(2)),
      Font.export({ size: Em(1) })
    ];
  }
}
