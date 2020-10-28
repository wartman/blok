package blok.style;

#if !blok.core.style
  #error "The blok.core.style package is required for blok.core.StyleToCssGenerator";
#end

import haxe.ds.Map;
import blok.style.VStyle;

using Lambda;
using StringTools;

enum CssResult {
  None;
  Definition(className:String, rules:String);
  Multiple(results:Array<CssResult>);
}

class StyleToCssGenerator {
  var uid:Int = 0;
  final prefix:String;
  final styleNameToClassName:Map<String, String> = [];

  public function new(prefix = '_b') {
    this.prefix = prefix;
  }

  // @todo: It may be more robust to use a hash that takes the Name as a
  //        seed and always generates the same result. Might also be 
  //        slower. Think on it, anyway. 
  public function getClassName(styleName:String) {
    if (!styleNameToClassName.exists(styleName)) {
      #if debug
        styleNameToClassName.set(styleName, prefix + '--' + styleName.split('--').shift() + '--' + uid++);
      #else
        styleNameToClassName.set(styleName, '${prefix}_${uid++}');
      #end
    }
    return styleNameToClassName.get(styleName);
  }

  public function generate(style:VStyle):CssResult {
    return switch style {
      case null: None;
      case VStyleDef(type, props, suffix):
        var name = type.getStyleName(props, suffix);
        var className = getClassName(name);
        return Definition(className, generateExprs('.$className', type.renderStyle(props)));
      case VStyleInline(name, def):
        var className = getClassName(name);
        return Definition(className, generateExprs('.$className', def()));
      case VStyleList(styles):
        return Multiple(styles.map(generate));
    }
  }

  function generateExprs(selector:String, exprs:Array<VStyleExpr>) {
    var out:Array<String> = [];
    var def:Array<String> = [];
    
    inline function applySelector(suffix:String) {
      return selector != null
        ? selector + ' ' + suffix
        : suffix;
    }

    function process(exprs:Array<VStyleExpr>) for (expr in exprs) if (expr != null) switch expr {
      case ENone | null:
      case ERaw(style):
        if (selector != null) {
          out.push('${selector} { ${style} }');
        } else {
          out.push(style);
        }
      case EProperty(name, value, important):
        var value = value.toString();
        if (value != null) if (important == true) {
          def.push('${name}: ${value} !important;');
        } else {
          def.push('${name}: ${value};');
        }
      case EChildren(exprs):
        process(exprs);
      case EScope(scope, expr): out.push(switch scope {
        case SGlobal: 
          generateExprs(null, [ expr ]);
        case SChild(value): 
          generateExprs(applySelector(value), [ expr ]);
        case SWrapper(value):
          '${value} { ${generateExprs(selector, [ expr ])} }';
        case SModifier(modifier):
          if (selector == null) {
          #if debug
            throw 'Cannot use a modifier without a selector';
          #else
            return;
          #end
          } else {
            generateExprs('${selector}${modifier}', [ expr ]);
          }
      });
    }

    process(exprs);

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
