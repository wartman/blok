package blok.internal;

import blok.internal.VStyle;

@:autoBuild(blok.internal.StyleBuilder.build())
class Style {
  public static inline function wrap(wrapper:VStyleWrapper, expr:VStyleExpr) {
    return EWrapped(wrapper, expr);
  }

  public inline static function raw(value:String):VStyleExpr {
    return ERaw(value);
  }

  public inline static function property(name:String, value:Value, ?important:Bool):VStyleExpr {
    return EProperty(name, value, important);
  }

  public static inline function properties(props:Array<VStyleExpr>) {
    return EChildren(props);
  }

  public function getName(suffix:Null<String>):String {
    return '';
  }

  public function render():Array<VStyleExpr> {
    return [];
  }
}
