package noted.data;

import blok.core.Record;

class Tag implements Record {
  @prop var id:Id<Tag>;
  @prop var name:String;
  @prop var notes:Array<Id<Note>>;
}
