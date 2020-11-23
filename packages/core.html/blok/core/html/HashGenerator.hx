package blok.core.html;

import haxe.crypto.Md5;
import haxe.Json;
import haxe.ds.Map;

// @todo: replace this with a real, non-cryptographic hashing solution
//        (such as Murmur3).
class HashGenerator {
  static var uid:Int = 0;
  static final cache:Map<String, String> = [];

  public static function generateHash(str:String, ?prefix:String) {
    if (!cache.exists(str)) {
      cache.set(str, (prefix != null ? prefix : '_') + '${Std.string(uid++)}');
    }
    return cache.get(str);
  }
}
