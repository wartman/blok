package blok.core;

import haxe.macro.Type;
import haxe.macro.Expr;

using haxe.macro.Tools;

class BuilderHelpers {
  public static function extractTypeParams(tp:TypeParameter) {
    return switch tp.t {
      case TInst(kind, _): switch kind.get().kind {
        case KTypeParameter(constraints): constraints.map(t -> t.toComplexType());
        default: [];
      }
      default: [];
    }
  }

  // This is a hack that I'm using probably because I don't understand
  // the Haxe type system well enough.
  //
  // Currently only used in StateBuilder to resolve type params when building
  // sub-states. There is probably a much safer way to do it.
  public static function mapTypes(type:Type, paramMap:Map<String, Type>) {
    function resolve(type:Type) {
      var resolved = switch type {
        case TType(t, params):
          if (params.length == 0) {
            followType(type);
          } else {
            followType(TType(t, params.map(resolve)));
          }
        case TInst(t, params): 
          if (params.length == 0) {
            followType(type);
          } else {
            followType(TInst(t, params.map(resolve)));
          }
        case TAbstract(t, params):
          if (params.length == 0) {
            followType(type);
          } else {
            followType(TAbstract(t, params.map(resolve)));
          }
        case TAnonymous(a):
          // this seems really damn brittle.
          var refFields = a.get().fields;
          var fields:Array<Field> = [ for (f in refFields) {
            name: f.name,
            pos: f.pos,
            meta: f.meta.get(),
            kind: switch f.kind {
              case FVar(_, _): FVar(resolve(f.type).toComplexType());
              // HMMMM
              case FMethod(_): throw 'assert';
            }
          }];
          // This can't be right.
          (TAnonymous(fields)).toType();
        case TFun(args, ret):
          var newArgs = [ for (arg in args) {
            {
              name: arg.name,
              opt: arg.opt,
              t: resolve(arg.t)
            }
          } ];
          var newRet:Type = resolve(ret);
          TFun(newArgs, newRet);
        default:
          followType(type);
      }

      var key = resolved.toString();
      var out = if (paramMap.exists(key)) {
        resolve(paramMap.get(key));
      } else {
        resolved;
      }
      
      return out;
    }

    return resolve(type);
  }

  static function followType(type:Type):Type {
    return switch (type) {
      case TType(t, params) if (Std.string(t) == 'Null'):
        followType(params[0]);
      default: type;
    }
  }
}
