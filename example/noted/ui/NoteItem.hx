package noted.ui;

import noted.ui.style.Layout;
import blok.Children;
import blok.ui.style.*;
import noted.ui.style.*;
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
        style: [
          LineBreak.style({}),
          Layout.style()
        ],
        children: [
          Html.h2({
            style: Font.style({ lineHeight: Em(2) }),
            children: [ Html.text(note.name) ]
          }),
          Badge.node({
            style: Alignment.end(),
            label: switch note.status {
              case Draft: 'Draft';
              case Published: 'Published';
              case Trashed: 'Trashed';
            }
          })
        ]
      }),
      Html.div({
        style: sectionStyle,
        children: [ Html.text(note.content) ]
      }),
      Html.div({
        style: LineBreak.style({}),
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
        style: [
          sectionStyle,
          Alignment.end()
        ],
        buttons: [
          Button.node({
            onClick: _ -> startEditing(),
            type: Important,
            child: Html.text('Edit')
          }),
          Button.node({
            onClick: _ -> Store.from(context).removeNote(note.id),
            child: Html.text('Remove')
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
        Store.from(context).updateNote(note.id, update.name, update.content, update.tags, update.status);
        stopEditing();
      },
      requestRemove: () -> Store.from(context).removeNote(note.id),
      requestClose: stopEditing
    });
  }
}
