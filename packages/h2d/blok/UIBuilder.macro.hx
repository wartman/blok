package blok;

import haxe.macro.Context;
import haxe.macro.Expr;

class UIBuilder {
  public static function build(classes:Array<String>) {
    var fields = Context.getBuildFields();

    // todo: parse the classes and get their public properties.
    //       use this to generate functions on the `blok.Ui` class.
    //       For example, `h2d.Flow` -> `blok.Ui.flow({ ...  })`.

    return fields;
  }
}
