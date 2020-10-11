package noted.ui;

import blok.ui.style.*;
import noted.ui.style.*;

using Blok;

class Badge extends Component {
  @prop var label:String;
  @prop var style:StyleList = null;

  override function render(context:Context) {
    return Html.span({
      style: [
        Pill.style({
          color: Config.lightColor,
          padding: None
        }),
        Display.style({ kind: Block }),
        style
      ],
      children: [ Html.text(label) ]
    });
  }
}
