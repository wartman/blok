package blok.html;

import blok.style.VStyle;

using Lambda;
using StringTools;

typedef CssResult = {
  classes:Array<String>,
  rules:Array<String>
}

class CssGenerator {
  static var uid:Int = 0;
  static final classNames:Map<String, String> = [];

  public static function generate(style:VStyle):CssResult {
    return switch style {
      case VStyleDef(type, props, suffix):
        var name = type.getStyleName(props, suffix);
        var className = getUniqueClassName(name);
        return {
          classes: [ className ],
          rules: [ generateExprs('.$className', type.renderStyle(props)) ]
        };
      case VStyleInline(name, def):
        var className = getUniqueClassName(name);
        return {
          classes: [ className ],
          rules: [ generateExprs('.$className', def()) ]
        };
      case VStyleList(styles):
        var out = styles.map(generate);
        return {
          classes: out.flatMap(r -> r.classes),
          rules: out.flatMap(r -> r.rules)
        };
    }
  }

  public static function generateExprs(selector:String, exprs:Array<VStyleExpr>) {
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

  public static function getUniqueClassName(name:String) {
    if (!classNames.exists(name)) {
      classNames.set(name, '_b_${uid++}');
    }
    return classNames.get(name);
  }

  // static function randomName() {
  //   function rand(from:Int, to:Int):Int {
  //     return from + Math.floor((to - from) * Math.random());
  //   }
  //   var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //   return '_b_' + [ for (i in 0...10) chars.charAt(rand(0, chars.length - 1)) ].join('');
  // }
}
