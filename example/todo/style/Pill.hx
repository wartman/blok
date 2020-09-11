package todo.style;

import blok.ui.style.*;

using Blok;

class Pill extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var centered:Bool = true;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('color', switch color.getKey() {
        case 'white' | 'light': Config.darkColor;
        case 'mid' | 'dark': Config.lightColor;
        case _: Config.darkColor; 
      }),
      Background.export({ color: color }),
      Display.export({ kind: Block }),
      Border.export({ 
        type: None,
        width: Px(0),
        radius: Em(1) 
      }),
      Font.export({
        size: Em(1),
        lineHeight: Em(2),
        align: centered ? Center : null
      }),
      Box.export({
        padding: EdgeInsets.symmetric(None, Em(.5)),
        height: Em(2)
      }),

      // Todo: this shouldn't be builtin
      Style.modifier(':disabled', [
        Background.export({
          color: Color.name('transparent')
        }),
        Border.export({
          width: Px(1),
          type: Solid,
          color: color
        }),
        Style.property('color', color)
      ])
    ];
  }
}
