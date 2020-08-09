package blok.internal;

using haxe.macro.Tools;

class BuilderHelpers {
  public static function extractTypeParams(tp:haxe.macro.Type.TypeParameter) {
    return switch tp.t {
      case TInst(kind, _): switch kind.get().kind {
        case KTypeParameter(constraints): constraints.map(t -> t.toComplexType());
        default: [];
      }
      default: [];
    }
  }
}
