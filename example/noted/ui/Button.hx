package noted.ui;

import blok.ui.style.Color;
import blok.ui.style.Display;
import noted.ui.style.Pill;

using Blok;

enum ButtonType {
  Normal;
  Important;
}

class Button extends Component {
  @prop var child:VNode;
  @prop var type:ButtonType = Normal;
  @prop var onClick:(e:js.html.Event)->Void = null;

  override function render(context:Context):VNode {
    return Html.button({
      style: [
        Display.style({ kind: Block }),
        Pill.style({
          backgroundColor: switch type {
            case Normal: Color.hex(0xffffff).withKey('normal');
            case Important: Color.hex(0x666666).withKey('important');
          }
        })
      ],
      attrs: {
        onclick: onClick
      },
      children: [ child ]
    });
  }
}
