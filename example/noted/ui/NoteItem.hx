package noted.ui;

import blok.ui.style.*;
import noted.state.Note;
import noted.state.NoteRepository;
import noted.ui.style.Config;
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
            Html.header({
              style: NoteItemSection.style(),
              children: [
                Html.h2({
                  children: [ Html.text(note.title) ]
                })
              ]
            }),
            Html.div({
              style: NoteItemSection.style(),
              children: [ Html.text(note.content) ]
            }),
            Html.div({
              style: NoteItemSection.style(),
              children: [ 
                NoteTags.node({ note: note })
              ]
            }),
            ButtonGroup.node({
              style: NoteItemSection.style(),
              buttons: [
                Button.node({
                  onClick: _ -> NoteRepository.from(context).removeNote(note),
                  child: Html.text('Remove')
                }),
                Button.node({
                  onClick: _ -> startEditing(),
                  child: Html.text('Edit')
                })
              ]
            })
          ] else [
            NoteEditor.node({
              note: note.copy(),
              onSave: update -> {
                note.setContent(update.title, update.content, update.tags);
                stopEditing();
              },
              requestRemove: () -> NoteRepository.from(context).removeNote(note),
              requestClose: stopEditing
            })
          ]
        })
      ]
    }));
  }
}

class NoteItemSection extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Box.export({
        spacing: EdgeInsets.bottom(Config.mediumGap)
      })
    ];
  }
}
