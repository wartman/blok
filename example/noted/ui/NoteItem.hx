package noted.ui;

import blok.Children;
import blok.ui.style.*;
import noted.ui.style.Config;
import noted.ui.style.Card;
import noted.data.Note;
import noted.data.Store;

using Blok;

class NoteItem extends Component {
  static final sectionStyle:StyleList = Box.style({
    spacing: EdgeInsets.bottom(Config.mediumGap)
  }, 'note-item-section');

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
    return Html.li({
      style: Card.style({}),
      key: note.id,
      children: 
        if (!editing) 
          display(context) 
        else 
          [ edit(context) ]
    });
  }

  inline function display(context:Context):Children {
    return [
      Html.header({
        style: sectionStyle,
        children: [
          Html.h2({
            children: [ Html.text(note.name) ]
          })
        ]
      }),
      Html.div({
        style: sectionStyle,
        children: [ Html.text(note.content) ]
      }),
      Html.div({
        style: sectionStyle,
        children: [ 
          NoteTags.node({
            tags: Store.from(context).getTagsForNote(note.id),
            addTag: (value) -> {
              var store = Store.from(context);
              switch store.findTagByName(value) {
                case Some(tag):
                  store.addTagToNote(note.id, tag.id);
                case None:
                  store.addTag(value, [ note.id ]);
              }
            },
            removeTag: id -> Store.from(context).removeTagFromNote(note.id, id)
          })
        ]
      }),
      ButtonGroup.node({
        style: sectionStyle,
        buttons: [
          Button.node({
            onClick: _ -> Store.from(context).removeNote(note.id),
            child: Html.text('Remove')
          }),
          Button.node({
            onClick: _ -> startEditing(),
            child: Html.text('Edit')
          })
        ]
      })
    ];
  }

  inline function edit(context:Context) {
    return NoteEditor.node({
      note: note.copy(),
      tags: Store.from(context).getTagsForNote(note.id),
      onSave: update -> {
        Store.from(context).updateNote(note.id, update.name, update.content, update.tags);
        stopEditing();
      },
      requestRemove: () -> Store.from(context).removeNote(note.id),
      requestClose: stopEditing
    });
  }
}
