package blok.internal;

import blok.internal.VStyle;

@:autoBuild(blok.internal.StyleBuilder.build())
class Style {
  public static inline function scope(scope:VStyleExprScope, expr:VStyleExpr) {
    return EScope(scope, expr);
  }

  public static inline function globalScope(expr:VStyleExpr) {
    return scope(SGlobal, expr);
  }

  public static inline function wrappedScope(name:String, expr:VStyleExpr) {
    return scope(SWrapper(name), expr);
  }
  
  public static inline function childScope(name:String, expr:VStyleExpr) {
    return scope(SChild(name), expr);
  }
  
  public static inline function modifierScope(modifier:String, expr:VStyleExpr) {
    return scope(SModifier(modifier), expr);
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
