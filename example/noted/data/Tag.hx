package noted.data;

typedef Tag = {
  public final id:Id<Tag>;
  public final name:String;
  public var notes:Array<Id<Note>>;
}
