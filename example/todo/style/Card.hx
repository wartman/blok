package todo.style;

import blok.style.*;

using Blok;

class Card extends Style {

  @prop var background:Color = Appearance.lightColor;

  override function render():Array<VStyle> {
    return [
      Box.export({
        padding: EdgeInsets.symmetric(Px(10), Px(20))
      }),
      Border.export({ 
        radius: Px(15)
      }),
      Background.export({
        color: background
      })
    ];
  }
  
}
