package blok.core.html;

#if !blok.core.style
  #error "Cannot use blok.core.html.Css without blok.core.style"
#end

import blok.core.style.StyleExpr;

class Css {
  public static macro function define(e) {
    return blok.core.html.CssBuilder.define(e);
  }

  public static macro function export(e) {
    return blok.core.html.CssBuilder.export(e);
  }

  public static inline function scope(scope:StyleExprScope, expr:StyleExpr):StyleExpr {
    return EScope(scope, expr);
  }

  public static inline function global(exprs:Array<StyleExpr>) {
    return scope(SGlobal, properties(exprs));
  }
  
  public static inline function child(name:String, exprs:Array<StyleExpr>) {
    return scope(SChild(name), properties(exprs));
  }
  
  public static inline function wrap(name:String, exprs:Array<StyleExpr>) {
    return scope(SWrapper(name), properties(exprs));
  }

  public static inline function properties(props:Array<StyleExpr>):StyleExpr {
    return EChildren(props);
  }
  
  public static inline function modifier(modifier:String, exprs:Array<StyleExpr>) {
    return scope(SModifier(modifier), properties(exprs));
  }

  public inline static function raw(value:String):StyleExpr {
    return ERaw(value);
  }

  public static inline function property(name:String, value:CssValue, ?important:Bool):StyleExpr {
    return EProperty(name, value.toString(), important);
  }
}
