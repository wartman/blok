package blok.html;

import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using haxe.macro.Tools;

class CssBuilder {
  static final ucase:EReg = ~/[A-Z]/g;
  
  public static function define(e:Expr):Expr {
    return switch e.expr {
      case EObjectDecl(decls) if (decls.length >= 0):
        return macro @:pos(e.pos) blok.core.Style.define([ $a{parse(decls)} ]);
      case EBlock(_) | EObjectDecl(_):
        macro null;
      default:
        Context.error('Should be an object', e.pos);
    }
  }

  public static function export(e:Expr):Expr {
    return switch e.expr {
      case EObjectDecl(decls) if (decls.length >= 0):
        return macro blok.core.Style.properties([ $a{parse(decls)} ]);
      case EBlock(_) | EObjectDecl(_):
        macro null;
      default:
        Context.error('Should be an object', e.pos);
    }
  }

  static function parse(rules:Array<ObjectField>) {
    var exprs:Array<Expr> = [];
    for (rule in rules) switch rule.expr.expr {
      case EObjectDecl(fields):
        exprs.push(macro blok.core.Style.child($v{rule.field}, [ $a{parse(fields)} ]));
      default:
        var key = prepareKey(rule.field);
        var e = rule.expr;
        exprs.push(macro @:pos(e.pos) blok.core.Style.property($v{key}, $e));
    }
    return exprs;
  }

  static function prepareKey(key:String) {
    return [ for (i in 0...key.length)
      if (ucase.match(key.charAt(i))) {
        if (i == 0)
          key.charAt(i).toLowerCase()
        else 
          '-' + key.charAt(i).toLowerCase();
      } else {
        key.charAt(i);
      } 
    ].join('');
  }
}
