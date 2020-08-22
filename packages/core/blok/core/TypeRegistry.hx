package blok.core;

class TypeRegistry<Node> implements Registry<Key, RNode<Node>> {
  var keyed:KeyRegistry<Node>;
  var unkeyed:Array<RNode<Node>>;

  public function new() {}

  public function put(?key:Key, value:RNode<Node>):Void {
    if (key == null) {
      if (unkeyed == null)
        unkeyed = [];
      unkeyed.push(value);
    } else {
      if (keyed == null)
        keyed = new KeyRegistry();
      keyed.put(key, value);
    }
  }

  public function pull(?key:Key):RNode<Node> {
    if (key == null) {
      return if (unkeyed != null) unkeyed.shift() else null;
    } else {
      return if (keyed != null) keyed.pull(key) else null;
    }
  }

  public function exists(key:Key):Bool {
    return if (keyed == null) false else keyed.exists(key);
  }

  public inline function each(cb:(comp:RNode<Node>) -> Void) {
    if (keyed != null)
      keyed.each(cb);
    if (unkeyed != null)
      for (k in unkeyed)
        cb(k);
  }
}
