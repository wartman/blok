package noted.ui;

import blok.core.foundation.style.*;
import noted.ui.style.*;

using Blok;

enum ButtonType {
  Normal;
  Important;
  Selected;
  Custom(color:Color);
}

class Button extends Component {
  @prop var child:VNode;
  @prop var type:ButtonType = Normal;
  @prop var disabled:Bool = false;
  @prop var onClick:(e:js.html.Event)->Void = null;
  @prop var style:StyleList = [];

  override function render(context:Context):VNode {
    var color = switch type {
      case Normal: Config.lightColor;
      case Important: Config.accentColor;
      case Selected: Config.midColor;
      case Custom(color): color;
    };
    return Html.button({
      style: [
        Box.style({ display: Block }),
        Selectable.style({ color: color }),
        Pill.style({
          outlined: type.equals(Selected),
          color: color
        }),
        Interactive.style({ cursor: Pointer }),
        style
      ],
      attrs: {
        disabled: disabled,
        onclick: if (disabled) null else onClick
      },
      children: [ child ]
    });
  }
}
