package noted.ui.style;

import blok.ui.style.*;

using Blok;

class LineBreak extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var gap:Unit = Config.mediumGap;
  @prop var spacing:Unit = Config.mediumGap;

  override function render():Array<VStyleExpr> {
    return [
      Box.export({
        padding: EdgeInsets.bottom(gap),
        spacing: EdgeInsets.bottom(spacing)
      }),
      Border.export({
        side: Bottom,
        color: color,
        width: Px(1),
        type: Solid
      })
    ];
  }
}
