package todo.style;

import blok.ui.style.Color;
import blok.ui.style.Background;

using Blok;

class AutoColor extends Style {
  @prop var color:Color;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', switch color.getKey() {
        case 'white' | 'light': Config.darkColor;
        case 'mid' | 'dark': Config.lightColor;
        case _: Config.darkColor; 
      }),
      Background.export({ color: color })
    ];
  }
}
