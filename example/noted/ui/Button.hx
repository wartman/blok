package noted.ui;

import noted.ui.style.Config;
import blok.ui.style.Color;
import blok.ui.style.Display;
import noted.ui.style.Pill;

using Blok;

enum ButtonType {
  Normal;
  Important;
  Custom(color:Color);
}

class Button extends Component {
  @prop var child:VNode;
  @prop var type:ButtonType = Normal;
  @prop var disabled:Bool = false;
  @prop var onClick:(e:js.html.Event)->Void = null;

  override function render(context:Context):VNode {
    return Html.button({
      style: [
        Display.style({ kind: Block }),
        Pill.style({
          color: switch type {
            case Normal: Config.lightColor;
            case Important: Config.darkColor;
            case Custom(color): color;
          }
        }),
        Style.define([
          Style.property('cursor', 'pointer')
        ])
      ],
      attrs: {
        disabled: disabled,
        onclick: if (disabled) null else onClick
      },
      children: [ child ]
    });
  }
}
