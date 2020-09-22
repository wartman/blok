package noted.ui;

import noted.state.Note;
import noted.state.NoteRepository;
import noted.ui.style.Card;

using Blok;

class NoteItem extends Component {
  @prop var note:Note;
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
    return note.getObservable().mapToNode(note -> Html.li({
      style: Card.style({}),
      key: note.id,
      children: [
        Html.div({
          children: if (!editing) [
            Html.h2({
              children: [ Html.text(note.title) ]
            }),
            Html.button({
              attrs: {
                onclick: _ -> NoteRepository.from(context).removeNote(note)
              },
              children: [ Html.text('Remove') ]
            }),
            Html.text(note.content),
            Html.button({
              attrs: {
                onclick: _ -> startEditing()
              },
              children: [ Html.text('Edit') ]
            }),
            NoteTags.node({ note: note })
          ] else [
            NoteEditor.node({
              note: note.copy(),
              onSave: update -> {
                note.setContent(update.title, update.content, update.tags);
                stopEditing();
              },
              requestClose: stopEditing
            })
          ]
        })
      ]
    }));
  }
}
