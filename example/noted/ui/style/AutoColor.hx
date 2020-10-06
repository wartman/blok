package noted.ui.style;

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
        case 'error': Config.whiteColor;
        case _: Config.darkColor; 
      }),
      Background.export({ color: color }),
      Style.modifier(':disabled', [
        Style.property('color', switch color.getKey() {
          case 'white' | 'light': Config.midColor;
          case 'mid' | 'dark': Config.lightColor;
          case _: Config.midColor; 
        }),
        Background.export({ color: switch color.getKey() {
          case 'white' | 'light': color;
          case 'dark': Config.midColor;
          default: color;
        } }),
      ])
    ];
  }
}
