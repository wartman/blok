package noted.data;

enum NoteStatus {
  Draft;
  Published;
  Trashed;
}

@:structInit
class Note {
  public static function empty():Note {
    return {
      id: Id.invalid(),
      name: '',
      content: '',
      tags: [],
      status: Draft
    };
  }

  public final id:Id<Note>;
  public var name:String;
  public var content:String;
  public var tags:Array<Id<Tag>>;
  public var status:NoteStatus = Draft;
  public var editing:Bool = false;

  public function copy():Note {
    return {
      id: Id.invalid(),
      name: name,
      content: content,
      tags: tags.copy(),
      status: status
    };
  }
}
