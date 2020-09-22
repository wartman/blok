package noted.ui.style;

import blok.ui.style.*;

using Blok;

class List extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Grid.export({ gap: Em(1) })
    ];
  }
}
