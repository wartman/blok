package noted.ui;

import blok.ui.style.*;
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
      color: Config.darkColor,
      padding: EdgeInsets.all(Config.smallGap)
    }),
    Display.style({ kind: Block }),
    Box.style({
      width: Pct(100)
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
    return if (validate(ref.value)) 
      UpdateState({ showMessage: false })
    else
      UpdateState({ showMessage: true });
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
      children: [
        input,
        if (showMessage) Html.span({
          style: [
            Display.style({ kind: Block }),
            Box.style({
              spacing: EdgeInsets.top(Em(1))
            }),
            Pill.style({ 
              color: Config.errorColor, 
              padding: Em(.5),
              // outlined: true,
              centered: false
            })
          ],
          children: [ Html.text(message) ]
        }) else null
      ]
    });
  }
}
