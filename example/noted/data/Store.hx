package noted.data;

import haxe.ds.Option;
import haxe.ds.ReadOnlyArray;

using Lambda;
using Blok;

enum NoteFilter {
  None;
  FilterAll;
  FilterByTags(tags:Array<Id<Tag>>);
}

class Store implements State {
  @prop var uid:Int;
  @prop var notes:ReadOnlyArray<Note>;
  @prop var tags:ReadOnlyArray<Tag>;
  @prop var filter:NoteFilter = None;
  @computed var filteredNotes:ReadOnlyArray<Note> = switch filter {
    case None: [];
    case FilterAll: notes;
    case FilterByTags(tags): 
      var notes:Array<Note> = [];
      for (tag in tags) {
        var tagNotes = getNotesForTag(tag);
        for (note in tagNotes) if (!notes.contains(note)) notes.push(note);
      }
      notes;
  }

  public function getNote(id:Id<Note>):Option<Note> {
    var note = notes.find(note -> note.id == id);
    return if (note == null)
      None;
    else
      Some(note); 
  }

  public function getTagsForNote(id:Id<Note>):Array<Tag> {
    return switch getNote(id) {
      case None: [];
      case Some(note): [ for (id in note.tags) switch getTag(id) {
        case Some(v): v;
        case None: null;
      } ].filter(t -> t != null);
    }
  }

  @update
  public function setFilter(filter:NoteFilter) {
    return UpdateState({
      filter: filter
    });
  }

  @update
  public function addNote(name:String, content:String, noteTags:Array<Id<Tag>>) {
    return UpdateState({
      uid: uid + 1,
      notes: notes.concat([ {
        id: uid,
        name: name,
        content: content,
        status: Draft,
        tags: noteTags
      } ]),
      tags: tags.map(tag -> {
        if (noteTags.contains(tag.id)) tag.notes.push(uid);
        tag;
      })
    });
  }

  @update
  public function updateNote(id:Id<Note>, name:String, content:String, noteTags:Array<Id<Tag>>) {
    if (id.isInvalid()) return None;
    return switch getNote(id) {
      case None: None;
      case Some(note): 
        note.name = name;
        note.content = content;
        note.tags = noteTags;

        UpdateState({
          tags: tags.map(tag -> {
            if (tag.notes.contains(note.id)) {
              if (!note.tags.contains(tag.id)) 
                tag.notes.remove(note.id);
            } else if (note.tags.contains(tag.id)) {
              tag.notes.push(note.id);
            }
            tag;
          })
        });
    }
  }

  @update
  public function removeNote(id:Id<Note>) {
    return UpdateState({
      notes: notes.filter(note -> note.id != id),
      tags: tags.map(tag -> {
        tag.notes.remove(id);
        tag;
      })
    });
  }

  public function getTag(id:Id<Tag>):Option<Tag> {
    if (id.isInvalid()) return None;
    var tag = tags.find(tag -> tag.id == id);
    return if (tag == null)
      None;
    else
      Some(tag); 
  }

  public function findTagByName(name:String):Option<Tag> {
    var tag = tags.find(tag -> tag.name == name);
    return if (tag == null)
      None;
    else
      Some(tag); 
  }

  public function getNotesForTag(id:Id<Tag>):Array<Note> {
    return switch getTag(id) {
      case None: [];
      case Some(tag): [ for (id in tag.notes) switch getNote(id) {
        case Some(v): v;
        case None: null;
      } ].filter(n -> n != null);
    }
  }

  @update
  public function addTagSilent(name:String, tagNotes:Array<Id<Note>>) {
    return UpdateStateSilent({
      uid: uid + 1,
      tags: tags.concat([ {
        id: uid,
        name: name,
        notes: tagNotes
      } ]),
      notes: notes.map(note -> {
        if (tagNotes.contains(note.id)) note.tags.push(uid);
        note;
      })
    });
  }

  @update
  public function addTag(name:String, tagNotes:Array<Id<Note>>) {
    return UpdateState({
      uid: uid + 1,
      tags: tags.concat([ {
        id: uid,
        name: name,
        notes: tagNotes
      } ]),
      notes: notes.map(note -> {
        if (tagNotes.contains(note.id)) note.tags.push(uid);
        note;
      })
    });
  }

  @update
  public function removeTag(id:Id<Tag>) {
    if (id.isInvalid()) return None;
    return UpdateState({
      notes: notes.map(note -> {
        note.tags.remove(id);
        note;
      }),
      tags: tags.filter(tag -> tag.id != id),
      filter: switch filter {
        case FilterByTags(filterTags):
          FilterByTags(filterTags.filter(tag -> tag != id));
        default: 
          filter;
      }
    });
  }

  @update
  public function addTagToNote(noteId:Id<Note>, tagId:Id<Tag>) {
    return UpdateState({
      notes: notes.map(note -> {
        if (
          note.id == noteId
          && !note.tags.contains(tagId)
        ) note.tags.push(tagId);
        note;
      }),
      tags: tags.map(tag -> {
        if (
          tag.id == tagId
          && !tag.notes.contains(noteId)
        ) tag.notes.push(noteId);
        tag;
      })
    });
  }

  @update
  public function removeTagFromNote(noteId:Id<Note>, tagId:Id<Tag>) {
    return UpdateState({
      notes: notes.map(note -> {
        if (note.id == noteId) note.tags.remove(tagId);
        note;
      }),
      tags: tags.map(tag -> {
        if (tag.id == tagId) tag.notes.remove(noteId);
        tag;
      })
    });
  }
}
