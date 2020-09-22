package noted.ui;

import noted.state.Note;
import noted.state.NoteRepository;
import noted.ui.style.List;

using Blok;

class NoteList extends Component {
  @prop var editing:Bool = false;

  @update
  function startEditing() {
    return UpdateState({ editing: true });
  }

  @update
  function stopEditing() {
    return UpdateState({ editing: false });
  }

  override function render(context:Context):VNode {
    return NoteRepository.observe(context, state -> Html.ul({
      style: List.style({}),
      children: [ 
        for (note in state.filteredNotes) 
          NoteItem.node({ note: note }) 
      ].concat([
        Html.li({
          children: [
            if (editing) NoteEditor.node({
              note: new Note({ title: '', status: Draft, content: '', tags: [] }),
              onSave: note -> {
                state.addNote(note);
                stopEditing();
              },
              requestClose: stopEditing
            }) else Button.node({
              type: Important,
              onClick: _ -> startEditing(),
              child: Html.text('Add Note')
            })
          ]
        })
      ])
    }));
  }
}
