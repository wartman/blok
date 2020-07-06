package todo.style;

import blok.style.*;

using Blok;

class Root extends Style {

  override function render():Array<VStyle> {
    return [
      VGlobal([
        Css.select('body', [
          Css.backgroundColor(Config.darkColor),
          Css.margin(EdgeInsets.all(Px(0))),
          Css.padding(EdgeInsets.all(Px(0)))
        ]),
        Font.select('body', {
          family: 'sans-serif',
          size: Px(13),
          color: Config.darkColor
        })
      ]),
      Layout.export({
        direction: Row
      }),
      Box.export({
        padding: EdgeInsets.all(Config.mediumGap)
      })
    ];
  }

}
