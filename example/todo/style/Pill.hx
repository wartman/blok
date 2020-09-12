package todo.style;

import blok.ui.style.*;

using Blok;

class Pill extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var outlined:Bool = false;
  @prop var centered:Bool = true;

  override function render():Array<VStyleExpr> {
    return [
      if (outlined) Style.properties([
        Background.export({
          color: Color.name('transparent')
        }),
        Border.export({
          radius: Em(1),
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
          radius: Em(1) 
        })
      ]),
      Display.export({ kind: Block }),
      Font.export({
        size: Em(1),
        lineHeight: Em(2),
        align: centered ? Center : null
      }),
      Box.export({
        padding: EdgeInsets.symmetric(None, Em(.5)),
        height: Em(2)
      })
    ];
  }
}
