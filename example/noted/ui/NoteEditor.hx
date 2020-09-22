package noted.ui;

import noted.state.Note;

using Blok;

class NoteEditor extends Component {
  @prop var note:Note;
  @prop var requestClose:()->Void;
  @prop var onSave:(note:Note)->Void;

  override function render(context:Context):VNode {
    return Html.div({
      children: [
        Html.input({
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
        Html.textarea({
          attrs: {
            name: 'content',
            value: note.content,
            oninput: e -> {
              var input:js.html.InputElement = cast e.target;
              note.setContent(note.title, input.value);
            }
          }
        }),
        NoteTags.node({
          note: note
        }),
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
    });
  }
}
