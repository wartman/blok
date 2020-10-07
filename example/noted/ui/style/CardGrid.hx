package noted.ui.style;

import blok.style.Style;
import blok.style.VStyle;
import blok.ui.style.*;
import blok.ui.style.Grid;

class CardGrid extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Grid.export({ gap: Config.mediumGap }),
      MediaQuery.minWidth(Config.mobileWidth, [
        Grid.export({
          columns: GridDefinition.repeat(4, Fr(1))
        })
      ]),
      MediaQuery.maxWidth(Config.mobileWidth, [
        Grid.export({
          columns: GridDefinition.repeat(2, Fr(1))
        })
      ])
    ];
  }
}
