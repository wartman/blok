package blok;

import js.Browser;
import js.html.Node;
import js.html.Event;
import js.html.Element;
import js.html.CSSStyleSheet;
import blok.core.VStyle;
import blok.core.Rendered;
import blok.core.StyleList;
import blok.ui.style.BaseStyle;

using StringTools;

class Engine implements blok.core.Engine<Node, Event> {
  static inline final RENDERED_PROP = '__blok_rendered';

  public final builder = new NativeNodeBuilder();

  final sheet:CSSStyleSheet;
  final defined:Array<String> = [];
  final definedClassNames:Array<String> = [];
  final indices:Map<String, Int> = [];

  public function new() {
    var el = Browser.document.createStyleElement();
    Browser.document.head.appendChild(el);
    sheet = cast el.sheet;

    var base = new BaseStyle({});
    addCss(base.getName(), base.render());
  }

  public function traverseSiblings(first:Node):Cursor {
    return new Cursor(first.parentNode, first);
  }

  public function traverseChildren(parent:Node):Cursor {
    return new Cursor(parent, parent.firstChild);
  }

  public function getRendered(node:Node):Null<Rendered<Node>> {
    return Reflect.field(node, RENDERED_PROP);
  }

  public function setRendered(node:Node, rendered:Null<Rendered<Node>>):Void {
    Reflect.setField(node, RENDERED_PROP, rendered);
  }

  public function applyStyles(node:Node, style:StyleList):Void {
    // Todo: this could likely be made much more efficient.
    switch Std.downcast(node, Element) {
      case null:
      case el:
        var classNames:Array<String> = [];
        function registerStyle(style:StyleList) {
          for (s in style) switch s {
            case VStyleDef(type, props, suffix):
              // Todo: we have way too many names to deal with here.
              //       We need to escape things better.
              var name = type.__generateName(props, suffix);
              var className = escapeClassName(name);

              classNames.push(className);

              if (!defined.contains(name)) {
                defined.push(name);
                definedClassNames.push(className);
                addCss('.${className}', type.__create(props).render());
              }
            case VStyleList(styles):
              registerStyle(styles);
          }
        }

        registerStyle(style);
        
        for (name in el.classList) {
          if (definedClassNames.contains(name) && !classNames.contains(name)) el.classList.remove(name);
        }
        for (name in classNames) {
          if (!el.classList.contains(name)) el.classList.add(name);
        }
    }
  }

  function addCss(name:String, props:Array<VStyleExpr>) {
    var css = generateCss(name, props);
    sheet.insertRule(
      '@media all { ${css} }',
      switch indices[name] {
        case null: indices[name] = sheet.cssRules.length;
        case v: v;
      }
    );
  }

  function generateCss(selector:String, exprs:Array<VStyleExpr>) {
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
        if (important == true) {
          def.push('${name}: ${value} !important;');
        } else {
          def.push('${name}: ${value};');
        }
      case EChildren(exprs):
        process(exprs);
      case EScope(scope, expr): out.push(switch scope {
        case SGlobal: 
          generateCss(null, [ expr ]);
        case SChild(value): 
          generateCss(applySelector(value), [ expr ]);
        case SWrapper(value):
          '${value} { ${generateCss(selector, [ expr ])} }';
        case SModifier(modifier):
          if (selector == null) {
          #if debug
            throw 'Cannot use a modifier without a selector';
          #end
          } else {
            generateCss('${selector}${modifier}', [ expr ]);
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

  function escapeClassName(name:String) {
    return name
      .replace('.', '_')
      .replace(' ', '_')
      .replace('#', '_')
      .replace('(', '_')
      .replace(')', '_')
      .replace('%', 'pct');
    // etc
  }
}
