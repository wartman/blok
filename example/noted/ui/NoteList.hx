package noted.ui;

import noted.ui.style.Card;
import blok.ui.style.Box;
import noted.ui.style.CardGrid;
import noted.ui.style.Config;
import noted.data.Note;
import noted.data.Store;
import noted.ui.style.List;

using Blok;

class NoteList extends Component {
  @prop var editing:Bool = false;
  @prop var asGrid:Bool = false;

  @update
  function startEditing() {
    return UpdateState({ editing: true });
  }

  @update
  function stopEditing() {
    return UpdateState({ editing: false });
  }

  @update
  function toggleDisplay() {
    return UpdateState({ asGrid: !asGrid });
  }

  override function render(context:Context):VNode {
    return Store.observe(context, state -> Html.div({
      style: [
        Box.style({
          width: Pct(100)
        }),
        List.style()
      ],
      children: [
        Html.div({
          style: List.style(),
          children: [
            NoteFilterControls.node({}),
            ButtonGroup.node({
              buttons: [
                Button.node({
                  type: Custom(Config.whiteColor),
                  onClick: _ -> toggleDisplay(),
                  child: if (asGrid) Html.text('As List') else Html.text('As Grid')
                })
              ]
            })
          ]
        }),
        Html.ul({
          style: if (asGrid) CardGrid.style() else List.style(),
          children: if (state.filteredNotes.length == 0) [
            Html.li({
              style: Card.style({
                color: Config.midColor
              }),
              children: [ Html.text('No notes yet!') ]
            })
          ] else [
            for (note in state.filteredNotes) 
              NoteItem.node({ note: note, asGrid: asGrid }) 
          ]
        }),
        Html.div({
          children: [
            if (editing) Modal.node({
              title: 'Create Note',
              requestClose: stopEditing,
              child: NoteEditor.node({
                note: Note.empty(),
                tags: [],
                onSave: note -> {
                  state.addNote(note.name, note.content, note.tags);
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
      ]
    }));
  }
}
