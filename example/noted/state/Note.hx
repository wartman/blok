package noted.state;

import blok.core.Observable;

using Blok;

enum NoteStatus {
  Draft;
  Published;
  Trashed;
}

class Note implements State {
  static var ids:Int = 0;

  @prop var id:Int = ids++;
  @prop var tags:Array<String>;
  @prop var title:String;
  @prop var content:String;
  @prop var status:NoteStatus = Draft;

  @update
  public function setStatus(status:NoteStatus) {
    if (this.status == status) return None;
    return UpdateState({
      status: status
    });
  }

  @update
  public function setContent(title:String, content:String, ?tags:Array<String>) {
    return UpdateState({
      title: title,
      content: content,
      tags: tags == null ? this.tags : tags 
    });
  }

  @update
  public function addTags(tags:Array<String>) {
    tags.filter(tag -> !this.tags.contains(tag));
    if (tags.length == 0) return null;
    return UpdateState({
      tags: this.tags.concat(tags)
    });
  }

  @update
  public function removeTags(tags:Array<String>) {
    return UpdateState({
      tags: this.tags.filter(tag -> !tags.contains(tag))
    });
  }

  public function copy() {
    return new Note(__props);
  }
}
