package noted.ui.style;

import blok.ui.style.*;

using Blok;

class List extends Style {
  override function render():StyleExpr {
    return Grid.export({ gap: Em(1) });
  }
}
