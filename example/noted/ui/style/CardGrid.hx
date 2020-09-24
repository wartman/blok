package noted.ui.style;

import blok.core.Style;
import blok.core.VStyle;
import blok.ui.style.*;
import blok.ui.style.Grid;

class CardGrid extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Box.export({ padding: EdgeInsets.symmetric(Config.mediumGap, None) }),
      Grid.export({ gap: Config.mediumGap }),
      MediaQuery.minWidth(Px(900), [
        Grid.export({
          columns: GridDefinition.repeat(4, Fr(1))
        })
      ]),
      MediaQuery.maxWidth(Px(900), [
        Grid.export({
          columns: GridDefinition.repeat(2, Fr(1))
        })
      ])
    ];
  }
}
