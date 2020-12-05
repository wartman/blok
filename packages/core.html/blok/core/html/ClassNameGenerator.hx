package blok.core.html;

import haxe.ds.Map;
class ClassNameGenerator {
  static var uid:Int = 0;
  static final cache:Map<String, String> = [];

  // @todo: replace this with a real, non-cryptographic hashing solution
  //        (such as Murmur3).
  public static function generateClassName(str:String, ?prefix:String) {
    if (!cache.exists(str)) {
      cache.set(str, (prefix != null ? prefix : '_') + '${Std.string(uid++)}');
    }
    return cache.get(str);
  }
}
