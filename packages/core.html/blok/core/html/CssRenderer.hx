package blok.core.html;

#if !blok.core.style
  #error "The blok.core.style package is required for blok.core.html.CssRenderer";
#end

import blok.core.style.VStyle;
import blok.core.style.StyleExpr;

using Lambda;
using StringTools;
using blok.core.html.HashGenerator;

enum CssRendererResult {
  None;
  Definition(className:String, rules:String);
  Multiple(results:Array<CssRendererResult>);
}

typedef CssRendererOptions = {
  public final prefix:String;
}

class CssRenderer {
  var uid:Int = 0;
  final options:CssRendererOptions;

  public function new(?options) {
    this.options = options != null ? options : { prefix: '_b'};
  }

  public function render(style:VStyle):CssRendererResult {
    return switch style {
      case null: None;
      case VStyleDef(type, props):
        var id = type.getStyleId(props);
        var className = renderClassName(id);
        return Definition(className, renderExpr('.$className', type.renderStyle(props)));
      case VStyleInline(id, def):
        var className = renderClassName(id);
        return Definition(className, renderExpr('.$className', def()));
      case VStyleList(styles):
        return Multiple(styles.map(render));
    }
  }

  public function renderClassName(id:String) {
    return id.generateHash(options.prefix);
  }

  function renderExpr(selector:String, expr:StyleExpr):String {
    var out:Array<String> = [];
    var def:Array<String> = [];
    
    inline function applySelector(suffix:String) {
      return selector != null
        ? selector + ' ' + suffix
        : suffix;
    }

    function process(expr:StyleExpr) if (expr != null) switch expr {
      case ENone | null:
      case ERaw(style):
        if (selector != null) {
          out.push('${selector} { ${style} }');
        } else {
          out.push(style);
        }
      case EProperty(name, rawValue, important):
        if (rawValue != null) {
          var value:String = cast rawValue;
          if (important == true) {
            def.push('${name}: ${value} !important;');
          } else {
            def.push('${name}: ${value};');
          }
        }
      case EChildren(exprs):
        for (expr in exprs) process(expr);
      case EScope(scope, expr): out.push(switch scope {
        case SGlobal: 
          renderExpr(null, expr);
        case SChild(value): 
          renderExpr(applySelector(value), expr);
        case SWrapper(value):
          '${value} { ${renderExpr(selector, expr)} }';
        case SModifier(modifier):
          if (selector == null) {
          #if debug
            throw 'Cannot use a modifier without a selector';
          #else
            return;
          #end
          } else {
            renderExpr('${selector}${modifier}', expr);
          }
        });
    }

    process(expr);

    if (def.length > 0) {
      if (selector == null) {
       #if debug
          throw 'Properties must be inside a selector';
        #else
          return out.join(' ');
        #end
      }
      out.unshift('${selector} { ${def.join(' ')} }');
    }

    return out.join(' ');
  }
}
