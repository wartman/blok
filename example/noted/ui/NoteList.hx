package noted.ui;

import blok.ui.style.Color;
import blok.ui.style.Shadow;
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

  @update
  function startEditing() {
    return UpdateState({ editing: true });
  }

  @update
  function stopEditing() {
    return UpdateState({ editing: false });
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
        NoteFilterControls.node({}),
        Html.ul({
          style: List.style(),
          children: if (state.filteredNotes.length == 0) [
            Html.li({
              style: Card.style({
                color: switch Store.from(context).filter {
                  case FilterAll | FilterByTags([]): Config.whiteColor;
                  default: Config.errorColor;
                }
              }),
              children: [ switch Store.from(context).filter {
                case FilterAll: Html.text('No notes yet!');
                case FilterByTags(tags) if (tags.length == 0): Html.text('Enter tags to filter by above'); 
                case FilterByTags(tags) if (tags.length > 0): Html.text('No notes found');
                default: Html.text('No notes found');
              } ]
            })
          ] else [
            for (note in state.filteredNotes) 
              NoteItem.node({ note: note }) 
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
              style: Shadow.style({
                offsetX: None,
                offsetY: None,
                radius: Em(1),
                color: Color.rgba(0, 0, 0, 0.1)
              }),
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
