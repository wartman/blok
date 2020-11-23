package noted.ui;

import noted.ui.style.Config;
import blok.ui.style.Color;
import blok.ui.style.Display;
import noted.ui.style.Pill;

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
    return Html.button({
      style: [
        Display.style({ kind: Block }),
        Pill.style({
          outlined: type.equals(Selected),
          color: switch type {
            case Normal: Config.lightColor;
            case Important: Config.accentColor;
            case Selected: Config.midColor;
            case Custom(color): color;
          }
        }),
        Css.define({ cursor: 'pointer' }),
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
