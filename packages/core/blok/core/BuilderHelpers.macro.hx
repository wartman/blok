package blok.core;

import haxe.macro.Type;

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
}
