package blok.core;

class KeyRegistry implements Registry<Key, Widget> {
  
  var strings:Map<String, Widget>;
  var objects:Map<{}, Widget>;

  public function new() {}

  public function put(?key:Key, value:Widget):Void {
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

  public function pull(?key:Key):Widget {
    if (key == null) return null;
    var map:Map<Dynamic, Widget> = if (key.isString()) strings else objects;
    if (map == null) return null;
    var out = map.get(key);
    map.remove(key);
    return out;
  }

  public function exists(key:Key):Bool {
    var map:Map<Dynamic, Widget> = if (key.isString()) strings else objects;
    if (map == null) return false;
    return map.exists(key);
  }

  public function each(cb:(value:Widget)->Void) {
    if (strings != null) for (v in strings) cb(v);
    if (objects != null) for (v in objects) cb(v);
  }

}
