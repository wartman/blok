package noted.data;

using Blok;

enum NoteStatus {
  Draft;
  Published;
  Trashed;
}

class Note implements Record {
  public static function empty():Note {
    return new Note({
      id: Id.invalid(),
      name: '',
      content: '',
      tags: [],
      status: Draft
    });
  }

  @constant var id:Id<Note>;
  @prop var name:String;
  @prop var content:String;
  @prop var tags:Array<Id<Tag>>;
  @prop var status:NoteStatus = Draft;
  @prop var editing:Bool = false;
}
