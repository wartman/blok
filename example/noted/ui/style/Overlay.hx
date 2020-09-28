package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Overlay extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Style.property('z-index', 99999),
      Background.export({
        color: Config.scrimColor
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
      MediaQuery.maxWidth(Config.mobileWidth, [
        Box.export({
          padding: EdgeInsets.all(Config.smallGap)
        })
      ])
    ];
  }
}
