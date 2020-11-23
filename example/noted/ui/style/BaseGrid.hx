package noted.ui.style;

import blok.ui.style.*;
import blok.ui.style.Grid;

using Blok;

class BaseGrid extends Style {
  @prop var perRow:Int = Config.defaultItemsPerRow;
  @prop var perRowMobile:Int = Config.defaultItemsPerRowMobile;
  @prop var gap:CssUnit = Config.mediumGap;

  override function render():StyleExpr {
    return Css.properties([
      Grid.export({ gap: gap }),
      MediaQuery.minWidth(Config.mobileWidth, [
        Grid.export({
          columns: GridDefinition.repeat(perRow, Fr(1))
        })
      ]),
      MediaQuery.maxWidth(Config.mobileWidth, [
        Grid.export({
          columns: GridDefinition.repeat(perRowMobile, Fr(1))
        })
      ])
    ]);
  }
}
