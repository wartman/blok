package blok;

import js.Browser;
import js.html.Node;
import js.html.Element;
import js.html.CSSStyleSheet;
import blok.internal.VStyle;
import blok.internal.Differ;
import blok.internal.VNode;
import blok.internal.Rendered;
import blok.internal.StyleList;
import blok.style.BaseStyle;

using StringTools;

class Engine implements blok.internal.Engine<Node> {
  static inline final RENDERED_PROP = '__blok_rendered';

  public final differ:Differ<Node>;
  final sheet:CSSStyleSheet;
  final defined:Map<String, Bool> = [];
  final indices:Map<String, Int> = [];

  public function new() {
    differ = new Differ();
    var el = Browser.document.createStyleElement();
    Browser.document.head.appendChild(el);
    sheet = cast el.sheet;
    registerStyle(VStyleDef(BaseStyle));
  }

  public function createPlaceholder(target:blok.internal.Component<Node>):VNode<Node> {
    return Html.text('');
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

  public function registerStyle(style:StyleList):Void {
    for (s in style) switch s {
      case VStyleDef(type, props, suffix):
        var name = type.__generateName(props, suffix);
        if (!defined.exists(name)) {
          defined.set(name, true);
          addCss(prepareSelector(name), type.__create(props).render());
        }
      case VStyleList(styles): 
        registerStyle(styles);
    }
  }

  public function applyStyles(node:Node, style:StyleList):Void {
    switch Std.downcast(node, Element) {
      case null:
      case el:
        registerStyle(style);
        var names = style.getNames().map(escapeClassName);
        var definedNames = [ for (key in defined.keys()) key ].map(escapeClassName);
        for (name in el.classList) {
          // seems iffy and innefficent, but this is how we might remove classes?
          if (definedNames.contains(name) && !names.contains(name)) el.classList.remove(name);
        }
        for (name in names) {
          if (!el.classList.contains(name)) el.classList.add(name);
        }
    }
  }

  function addCss(name:String, props:Array<VStyleExpr>) {
    var css = generateCss(name, props);
    trace(css);
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
      case EWrapped(wrapper, expr): out.push(switch wrapper {
        case WGlobal: 
          generateCss(null, [ expr ]);
        case WCustom(value): 
          generateCss(applySelector(value), [ expr ]);
        case WParent(value):
          '${value} { ${generateCss(selector, [ expr ])} }';
        case WModifier(modifier):
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

  function prepareSelector(name:String) {
    return '.${escapeClassName(name.trim())}';
  }
}
