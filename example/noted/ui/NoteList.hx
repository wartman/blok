package noted.ui;

import noted.ui.style.Config;
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
      style: List.style(),
      children: [ 
        for (note in state.filteredNotes) 
          NoteItem.node({ note: note }) 
      ].concat([
        Html.li({
          children: [
            if (editing) Modal.node({
              title: 'Create Note',
              requestClose: stopEditing,
              child: NoteEditor.node({
                note: new Note({ 
                  title: '', 
                  status: Draft, 
                  content: '', 
                  tags: [] 
                }),
                onSave: note -> {
                  state.addNote(note);
                  stopEditing();
                },
                requestClose: stopEditing
              }) 
            }) else null,
            Button.node({
              type: Custom(Config.whiteColor),
              onClick: _ -> startEditing(),
              child: Html.text('Add Note')
            })
          ]
        })
      ])
    }));
  }
}
