package todo.style;

import blok.style.*;

using Blok;

class Root extends Style {

  override function render():Array<VStyle> {
    return [
      VGlobal([
        VRaw('
          html, body {
            margin: 0;
            padding: 0;
          }
        '),
        VChild('body', [
          VProperty('background-color', Config.darkColor)
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
