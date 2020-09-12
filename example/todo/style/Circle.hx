package todo.style;

import blok.ui.style.*;

using Blok;

class Circle extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var outlined:Bool = false;

  override function render():Array<VStyleExpr> {
    return [
      if (outlined) Style.properties([
        Background.export({
          color: Color.name('transparent')
        }),
        Border.export({
          radius: Pct(50),
          width: Px(1),
          type: Solid,
          color: color
        }),
        Style.property('color', color)
      ]) else Style.properties([
        AutoColor.export({ color: color }),
        Border.export({
          type: None,
          width: Px(0),
          radius: Pct(50) 
        }),
      ]),
      Box.export({
        padding: EdgeInsets.symmetric(None, Em(.5)),
        height: Em(2),
        width: Em(2)
      }),
      Font.export({
        lineHeight: Em(2)
      })
    ];
  }
}
