package blok;

import haxe.macro.Context;
import haxe.macro.Expr;

class UIBuilder {
  public static function build(types:Array<String>) {
    var fields = Context.getBuildFields();
    
    for (t in types) switch Context.getType(t) {
      case TInst(t, params):
        var cls = t.get();
        var fields = cls.fields;
        // todo
      default:
    }

    // todo: parse the classes and get their public properties.
    //       use this to generate functions on the `blok.Ui` class.
    //       For example, `h2d.Flow` -> `blok.Ui.flow({ ...  })`.

    return fields;
  }
}
