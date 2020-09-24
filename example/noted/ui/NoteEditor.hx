package noted.ui;

import blok.ui.style.*;
import noted.state.Note;
import noted.ui.style.*;

using Blok;

class NoteEditor extends Component {
  @prop var note:Note;
  @prop var requestClose:()->Void;
  @prop var onSave:(note:Note)->Void;

  override function render(context:Context):VNode {
    return Html.div({
      children: [
        Html.div({
          style: NoteEditorSection.style({}),
          children: [
            Html.input({
              style: NoteEditorInput.style({}),
              attrs: {
                name: 'title',
                type: Text,
                value: note.title,
                oninput: e -> {
                  var input:js.html.InputElement = cast e.target;
                  note.setContent(input.value, note.content);
                }
              }
            }),
          ]
        }),
        Html.div({
          style: NoteEditorSection.style({}),
          children: [
            Html.textarea({
              style: NoteEditorInput.style({}),
              attrs: {
                name: 'content',
                value: note.content,
                oninput: e -> {
                  var input:js.html.InputElement = cast e.target;
                  note.setContent(note.title, input.value);
                }
              }
            }),
          ]
        }),
        Html.div({
          style: NoteEditorSection.style({}),
          children: [
            NoteTags.node({
              note: note
            })
          ]
        }),
        ButtonGroup.node({
          buttons: [
            Button.node({
              onClick: _ -> {
                onSave(note);
                requestClose();
              },
              child: Html.text('Save')
            }),
            Button.node({
              onClick: _ -> requestClose(),
              child: Html.text('Cancel')
            })
          ]
        })
      ]
    });
  }
}

class NoteEditorSection extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Box.export({
        spacing: EdgeInsets.bottom(Config.mediumGap)
      })
    ];
  }
}

class NoteEditorInput extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Card.export({
        outlined: true,
        color: Config.darkColor,
        padding: EdgeInsets.all(Config.smallGap)
      }),
      Display.export({ kind: Block }),
      Box.export({
        width: Pct(100)
      })
    ];
  }
}
