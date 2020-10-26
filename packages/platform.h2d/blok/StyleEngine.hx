package blok;

import blok.h2d.NativeObject;
import h2d.Object;
import blok.core.Style;
import blok.core.VStyle;
import blok.core.StyleList;

// This is going to need a LOT of new work.
// We might just use DomKit under the hood?
class StyleEngine {
  public function new() {}

  // @todo: this is a mess, but it's just to get things started
  public function apply(object:Object, styles:StyleList) {
    if (!(object is NativeObject)) return;
    var native:NativeObject = cast object;
    var names:Array<String> = [];

    for (style in styles) switch style {
      case VStyleDef(type, props, suffix):
        var name = type.__generateName(props, suffix);
        names.push(name);
        if (!native.classList.has(name)) {
          trace(name);
          native.classList.add(name);
          applyStyle(object, type.__create(props).render());
        }
      case VStyleInline(name, def):
        names.push(name);
        if (!native.classList.has(name)) {
          trace(name);
          native.classList.add(name);
          applyStyle(object, def());
        }
      case VStyleList(styles):
        apply(object, styles);
    }

    for (name in native.classList) {
      if (!names.contains(name)) native.classList.remove(name);
    }
  }

  // @todo: this is a bad way to do things
  function applyStyle(obj:Object, rules:Array<VStyleExpr>) {
    trace(Type.getClassName(Type.getClass(obj)));
    function apply(rules:Array<VStyleExpr>) {
      for (rule in rules) switch rule {
        case ENone:
        case EProperty(name, value, important): switch value {
          case ValueSingle(value):
            Reflect.setProperty(obj, parseName(name), value); 
          default:
        }
        case EScope(scope, expr):
        case EChildren(exprs):
          apply(exprs);
        case ERaw(style):
      }
    }
    apply(rules);
  }

  function parseName(name:String) {
    var parts = name.split('-');
    var first = parts.shift();
    if (parts.length == 0) return first;
    return first + parts
      .map(part -> part.substr(0, 1).toUpperCase() + part.substr(1))
      .join('');
  }
}
