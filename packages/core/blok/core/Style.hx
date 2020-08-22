package blok.core;

import blok.core.VStyle;

@:autoBuild(blok.core.StyleBuilder.build())
class Style {
  public static inline function scope(scope:VStyleExprScope, expr:VStyleExpr) {
    return EScope(scope, expr);
  }

  public static inline function global(exprs:Array<VStyleExpr>) {
    return scope(SGlobal, properties(exprs));
  }

  public static inline function wrap(name:String, exprs:Array<VStyleExpr>) {
    return scope(SWrapper(name), properties(exprs));
  }
  
  public static inline function child(name:String, exprs:Array<VStyleExpr>) {
    return scope(SChild(name), properties(exprs));
  }
  
  public static inline function modifier(modifier:String, exprs:Array<VStyleExpr>) {
    return scope(SModifier(modifier), properties(exprs));
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
