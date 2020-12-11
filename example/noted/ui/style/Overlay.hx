package noted.ui.style;

import blok.core.foundation.style.*;

using Blok;

class Overlay extends Style {
  override function render():StyleExpr {
    return Css.properties([
      Css.property('z-index', 99999),
      Css.property('overflow-y', 'scroll'),
      Box.export({
        backgroundColor: Config.scrimColor
      }),
      Position.export({
        type: Fixed,
        top: Px(0),
        bottom: Px(0),
        left: Px(0),
        right: Px(0)
      }),
      Flex.export({
        direction: Row,
        wrap: Wrap,
        justifyContent: Content(Center),
        alignItems: Position(Center)
      }),
      MediaQuery.export({
        maxWidth: Config.mobileWidth, 
        rules: [
          Box.export({
            padding: EdgeInsets.all(Config.smallGap)
          })
        ]
      })
    ]);
  }
}
