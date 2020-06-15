package blok.core;

class TypeRegistry implements Registry<Key, Widget> {

  var keyed:KeyRegistry;
  var unkeyed:Array<Widget>;

  public function new() {}

  public function put(?key:Key, value:Widget):Void {
    if (key == null) {
      if (unkeyed == null) unkeyed = [];
      unkeyed.push(value);
    } else {
      if (keyed == null) keyed = new KeyRegistry();
      keyed.put(key, value);
    }
  }

  public function pull(?key:Key):Widget {
    if (key == null) {
      return if (unkeyed != null) unkeyed.shift() else null;
    } else {
      return if (keyed != null) keyed.pull(key) else null;
    }
  }

  public function exists(key:Key):Bool {
    return if (keyed == null) false else keyed.exists(key);
  }

  public inline function each(cb:(comp:Widget)->Void) {
    if (keyed != null) keyed.each(cb);
    if (unkeyed != null) for (k in unkeyed) cb(k);
  }

}
