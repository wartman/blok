package todo.style;

import blok.style.Font;
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
          VProperty('background-color', Appearance.darkColor)
        ]),
        Font.exportAsChild('body', {
          family: 'sans-serif',
          size: Px(13),
          color: Appearance.darkColor
        })
      ])
    ];
  }

}
