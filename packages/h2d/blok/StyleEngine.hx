package blok;

import h2d.Object;
import blok.core.Style;
import blok.core.VStyle;
import blok.core.StyleList;

// This is going to need a LOT of new work.
// We might just use DomKit under the hood?
class StyleEngine {
  public function new() {}

  public function apply(object:Object, styles:StyleList) {
      for (style in styles) switch style {
        case VStyleDef(type, props, suffix):
          var name = type.__generateName(props, suffix);
          // todo: check object for existing styles
          applyStyle(object, type.__create(props));
        case VStyleList(styles):
          apply(object, styles);
      }
  }

  // todo: this is a bad way to do things
  function applyStyle(obj:Object, style:Style) {
    function apply(rules:Array<VStyleExpr>) {
      for (rule in rules) switch rule {
        case ENone:
        case EProperty(name, value, important): switch value {
          case ValueSingle(value): Reflect.setProperty(obj, name, value); 
          default:
        }
        case EScope(scope, expr):
        case EChildren(exprs):
          apply(exprs);
        case ERaw(style):
      }
    }
    apply(style.render());
  }
}
