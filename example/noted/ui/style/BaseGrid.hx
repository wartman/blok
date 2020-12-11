package noted.ui.style;

import blok.core.foundation.style.*;
import blok.core.foundation.style.Grid;

using Blok;

class BaseGrid extends Style {
  @prop var perRow:Int = Config.defaultItemsPerRow;
  @prop var perRowMobile:Int = Config.defaultItemsPerRowMobile;
  @prop var gap:CssUnit = Config.mediumGap;

  override function render():StyleExpr {
    return Css.properties([
      Grid.export({ gap: gap }),
      MediaQuery.export({
        minWidth: Config.mobileWidth,
        rules: [
          Grid.export({
            columns: GridDefinition.repeat(perRow, Fr(1))
          })
        ]
      }),
      MediaQuery.export({
        maxWidth: Config.mobileWidth,
        rules: [
          Grid.export({
            columns: GridDefinition.repeat(perRowMobile, Fr(1))
          })
        ]
      })
    ]);
  }
}
