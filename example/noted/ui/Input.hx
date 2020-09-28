package noted.ui;

import js.html.InputElement;
import noted.ui.style.*;

using Blok;

class Input extends Component {
  static final baseStyle:StyleList = [
    Pill.style({
      outlined: true,
      color: Config.darkColor,
      centered: false,
      padding: Em(.5)
    })
  ];

  @prop var style:StyleList = null;
  @prop var initialValue:String = null;
  @prop var placeholder:String = null;
  @prop var onSave:(value:String)->Void;
  @prop var onCancel:()->Void;
  var ref:InputElement;

  @effect
  function focus() {
    ref.focus();
  }

  override function render(context:Context) {
    return Html.input({
      style: baseStyle.add(style),
      ref: el -> ref = cast el,
      attrs: {
        placeholder: placeholder,
        value: initialValue,
        onblur: _ ->  onCancel(),
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
