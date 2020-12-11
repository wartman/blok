package noted.ui;

import js.html.InputElement;
import blok.core.foundation.style.Box;
import noted.ui.style.*;

using StringTools;
using Blok;

class Input extends Component {
  static final baseStyle:StyleList = [
    Pill.style({
      outlined: true,
      color: Config.midColor,
      centered: false,
      padding: Em(.5)
    }),
    Selectable.style({ color: Config.midColor }),
    Box.style({ width: Pct(100) })
  ];

  @prop var style:StyleList = [];
  @prop var initialValue:String = null;
  @prop var placeholder:String = null;
  @prop var onSave:(value:String)->Void;
  @prop var onCancel:()->Void;
  var ref:InputElement;

  override function render(context:Context) {
    return Html.input({
      style: baseStyle.add(style),
      ref: el -> {
        ref = cast el;
        ref.focus();
      },
      attrs: {
        placeholder: placeholder,
        value: initialValue,
        onblur: _ -> {
          if (ref.value.trim().length > 0) {
            onSave(ref.value);
          } else {
            onCancel();
          }
        },
        onkeydown: e -> {
          var ev:js.html.KeyboardEvent = cast e;
          var input:js.html.InputElement = cast ev.target;
          if (ev.key == 'Enter') {
            onSave(input.value);
          } else if (ev.key == 'Escape') {
            onCancel();
          }
        }
      }
    });
  }
}
