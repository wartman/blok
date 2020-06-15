package todo.state;

class Todo {

  public static function fromJson(data:{ id:Int, content:String, complete:Bool }) {
    return new Todo(data.content, data.id, data.complete);
  }

  public final id:Int;
  public var content:String;
  public var complete:Bool = false;

  public function new(content, id:Int, complete:Bool = false) {
    this.content = content;
    this.id = id;
    this.complete = complete;
  }

  public function toJson() {
    return {
      id: id,
      content: content,
      complete: complete
    };
  }

}
