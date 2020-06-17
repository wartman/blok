package todo.style;

import blok.style.Color;

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

          body {
            font-size: 13px;
          }
        '),
        VChild('body', [
          VProperty('background-color', Appearance.darkColor)
        ])
      ])
    ];
  }

}
