package noted.ui;

import blok.ui.style.*;
import noted.data.Id;
import noted.data.Store;
import noted.data.Note;
import noted.data.Tag;
import noted.ui.style.*;
import noted.ui.tag.TagList;

using StringTools;
using Blok;

// @todo: rethink the way this editor works
class NoteEditor extends Component {
  static final noteEditorSection = Box.style({
    spacing: EdgeInsets.bottom(Config.mediumGap)
  });
  
  @prop var note:Note;
  @prop var requestClose:()->Void;
  @prop var requestRemove:()->Void = null;
  @prop var onSave:(note:Note)->Void;
  @prop var tags:Array<Tag>;
  var isValid:Observable<Bool>;

  @init
  function setup() {
    isValid = new Observable(note.name.length > 0 && note.content.length > 0);
  }

  // @todo: this is pretty hacky
  @update
  function addTag(context:Context, name:String) {
    var store = Store.from(context);
    return UpdateState({
      tags: tags.concat([
        switch store.findTagByName(name) {
          case Some(tag):
            if (!note.tags.contains(tag.id)) note.tags.push(tag.id);
            tag;
          case None: 
            note.tags.push(store.uid);
            var ret:Tag = { id: store.uid, name: name, notes: [] };
            store.addTagSilent(name, []); // this seems dicy.
            ret;
        }
      ])
    });
  }

  // @todo: this is pretty hacky
  @update
  function removeTag(id:Id<Tag>) {
    note.tags = note.tags.filter(i -> i != id);
    return UpdateState({
      tags: tags.filter(tag -> tag.id != id)
    });
  }

  override function render(context:Context):VNode {
    return Html.div({
      children: [
        Html.div({
          style: noteEditorSection,
          children: [
            NoteEditorInput.node({
              name: 'title',
              message: 'A title is required',
              autoFocus: true,
              initialValue: note.name,
              placeholder: 'Title',
              validate: text -> {
                var v = text.trim().length > 0;
                isValid.notify(v);
                return v;
              },
              onInput: value -> note.name = value
            })
          ]
        }),
        Html.div({
          style: noteEditorSection,
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
              onInput: value -> note.content = value
            })
          ]
        }),
        Html.div({
          style: LineBreak.style({}),
          children: [
            TagList.node({
              tags: tags,
              addTag: addTag.bind(context),
              removeTag: removeTag,
              requestSearch: null
            })
          ]
        }),
        ButtonGroup.node({
          buttons: [
            isValid.mapToVNode(valid -> Button.node({
              disabled: !valid,
              onClick: _ -> {
                note.status = Published;
                onSave(note);
                requestClose();
              },
              type: Important,
              child: Html.text('Publish')
            })),
            isValid.mapToVNode(valid -> Button.node({
              disabled: !valid,
              onClick: _ -> {
                note.status = Draft;
                onSave(note);
                requestClose();
              },
              type: Important,
              child: Html.text('Save as Draft')
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

