package noted.ui;

import blok.core.foundation.style.*;
import noted.ui.style.*;

using Blok;

enum NoteEditorInputType {
  TextArea;
  Normal;
}

class NoteEditorInput extends Component {
  final style:StyleList = [
    Card.style({
      outlined: true,
      color: Config.midColor,
      padding: EdgeInsets.all(Config.smallGap)
    }),
    Selectable.style({ color: Config.midColor }),
    Box.style({
      width: Pct(100),
      display: Block
    })
  ];

  @prop var type:NoteEditorInputType = Normal;
  @prop var name:String;
  @prop var initialValue:String = null;
  @prop var placeholder:String = null;
  @prop var onInput:(value:String)->Void;
  @prop var validate:(value:String)->Bool;
  @prop var message:String;
  @prop var showMessage:Bool = false;
  @prop var autoFocus:Bool = false;
  var ref:{ value:String, focus:()->Void };

  @update
  function doValidation() {
    return UpdateState({
      showMessage: !validate(ref.value)
    });
  }

  @update
  function hideMessage() {
    return UpdateState({
      showMessage: false
    });
  }

  override function render(context:Context) {
    var input = switch type {
      case Normal: Html.input({
        style: style,
        ref: el -> {
          ref = cast el;
          if (autoFocus) ref.focus();
        },
        attrs: {
          name: name,
          type: Text,
          value: initialValue,
          placeholder: placeholder,
          onblur: _ -> doValidation(),
          oninput: _ -> {
            doValidation();
            onInput(ref.value);
          }
        }
      });
      case TextArea: Html.textarea({
        style: style,
        ref: el -> ref = cast el,
        attrs: {
          name: name,
          value: initialValue,
          placeholder: placeholder,
          onblur: _ -> doValidation(),
          oninput: _ -> {
            doValidation();
            onInput(ref.value);
          }
        }
      });
    }

    return Html.div({
      style: [
        Position.style({
          type: Relative
        })
      ],
      children: [
        input,
        if (showMessage) Popover.node({
          onClick: hideMessage,
          content: message
        }) else null
      ]
    });
  }
}
