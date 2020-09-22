package noted.state;

import noted.state.Note;

using Blok;

enum NoteFilter {
  All;
  AllWithTag(tag:String);
  Status(status:NoteStatus);
  StatusWithTag(status:NoteStatus, tag:String);
}

@:access(noted.state.Note)
class NoteRepository implements State {
  @prop var notes:Array<Note>;
  @prop var filter:NoteFilter = All;
  @computed var filteredNotes:Array<Note> = switch filter {
    case All: notes;
    case AllWithTag(tag): notes.filter(note -> note.tags.contains(tag));
    case Status(status): notes.filter(note -> note.status.equals(status));
    case StatusWithTag(status, tag): notes.filter(note -> 
      note.status.equals(status)
      && note.tags.contains(tag)
    );
  }

  @update
  public function addNote(note:Note) {
    return UpdateState({
      notes: notes.concat([ note ])
    });
  }

  @update
  public function removeNote(note:Note) {
    if (!notes.contains(note)) return None;
    return UpdateState({
      notes: notes.filter(n -> n != note)
    });
  }

  @update
  public function addTagsToNote(note:Note, tags:Array<String>) {
    note.addTags(tags);
    if (!notes.contains(note)) return None;
    return Update;
  }

  @update
  public function removeTagsFromNote(note:Note, tags:Array<String>) {
    note.removeTags(tags);
    if (!notes.contains(note)) return None;
    return Update;
  }
}
