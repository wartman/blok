package todo.style;

import blok.style.*;

using Blok;

class Card extends Style {

  override function render():Array<VStyle> {
    return [
      Box.export({
        padding: Spacing.sides(Px(10), Px(20))
      }),
      Border.export({ 
        radius: Px(15)
      }),
      Background.export({
        color: Appearance.lightColor
      })
    ];
  }
  
}
