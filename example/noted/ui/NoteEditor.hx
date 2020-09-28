package noted.ui;

import blok.ui.style.*;
import noted.state.Note;
import noted.ui.style.*;

using StringTools;
using Blok;

class NoteEditor extends Component {
  @prop var note:Note;
  @prop var requestClose:()->Void;
  @prop var requestRemove:()->Void = null;
  @prop var onSave:(note:Note)->Void;
  var isValid:Observable<Bool>;

  @init
  function setup() {
    isValid = new Observable(note.title.length > 0 && note.content.length > 0);
  }

  override function render(context:Context):VNode {
    return Html.div({
      children: [
        Html.div({
          style: NoteEditorSection.style(),
          children: [
            NoteEditorInput.node({
              name: 'title',
              message: 'A title is required',
              autoFocus: true,
              initialValue: note.title,
              placeholder: 'Title',
              validate: text -> {
                var v = text.trim().length > 0;
                isValid.notify(v);
                return v;
              },
              onInput: value -> note.setContent(value, note.content)
            })
          ]
        }),
        Html.div({
          style: NoteEditorSection.style(),
          children: [
            NoteEditorInput.node({
              type: TextArea,
              name: 'content',
              initialValue: note.content,
              placeholder: 'Content',
              message: 'Content is required',
              validate: text -> {
                var v = text.trim().length > 0;
                isValid.notify(v);
                return v;
              },
              onInput: value -> note.setContent(note.title, value)
            })
          ]
        }),
        Html.div({
          style: NoteEditorSection.style(),
          children: [
            NoteTags.node({
              note: note
            })
          ]
        }),
        ButtonGroup.node({
          buttons: [
            isValid.mapToNode(valid -> Button.node({
              disabled: !valid,
              onClick: _ -> {
                onSave(note);
                requestClose();
              },
              child: Html.text('Save')
            })),
            if (requestRemove != null) Button.node({
              onClick: _ -> requestRemove(),
              child: Html.text('Remove')
            }) else null,
            Button.node({
              onClick: _ -> requestClose(),
              child: Html.text('Cancel')
            }),
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
