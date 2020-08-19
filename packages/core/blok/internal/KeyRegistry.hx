package blok.internal;

class KeyRegistry<Node> implements Registry<Key, RNode<Node>> {
  var strings:Map<String, RNode<Node>>;
  var objects:Map<{}, RNode<Node>>;

  public function new() {}

  public function put(?key:Key, value:RNode<Node>):Void {
    if (key == null) {
      throw 'Key cannot be null';
    } if (key.isString()) {
      if (strings == null) strings = [];
      strings.set(cast key, value);
    } else {
      if (objects == null) objects = [];
      objects.set(key, value);
    }
  }

  public function pull(?key:Key):RNode<Node> {
    if (key == null) return null;
    var map:Map<Dynamic, RNode<Node>> = if (key.isString()) strings else objects;
    if (map == null) return null;
    var out = map.get(key);
    map.remove(key);
    return out;
  }

  public function exists(key:Key):Bool {
    var map:Map<Dynamic, RNode<Node>> = if (key.isString()) strings else objects;
    if (map == null) return false;
    return map.exists(key);
  }

  public function each(cb:(value:RNode<Node>)->Void) {
    if (strings != null) for (v in strings) cb(v);
    if (objects != null) for (v in objects) cb(v);
  }
}
