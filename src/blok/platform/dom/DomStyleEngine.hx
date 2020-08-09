package blok.platform.dom;

import js.Browser;
import js.html.CSSStyleSheet;
import blok.core.VStyle;
import blok.style.BaseStyle;

using StringTools;

class DomStyleEngine {

  final sheet:CSSStyleSheet;
  final defined:Map<String, Bool> = [];
  final indices:Map<String, Int> = [];

  public function new() {
    var el = Browser.document.createStyleElement();
    
    Browser.document.head.appendChild(el);
    sheet = cast el.sheet;

    // Todo: There may be a better place for this?
    define(BaseStyle.id, BaseStyle.get);
  }

  public function exists(name:String):Bool {
    return defined[name] == true;
  }

  public function define(name:String, css:()->VStyleDecl):Void {
    if (!defined[name]) {
      add(name, renderStyle(css()));
      defined[name] = true;
    }
  }

  function add(name:String, css:String) {
    trace(css);
    sheet.insertRule(
      '@media all { ${css} }',
      switch indices[name] {
        case null: indices[name] = sheet.cssRules.length;
        case v: v;
      }
    );
  }

  function renderStyle(style:VStyleDecl):String {
    return switch style {
      case VCustomStyle(type, attrs, suffix):
        renderStyle(type.__render(attrs, suffix));

      case VGlobal(props):
        renderProps(null, props);

      case VClass(_, props):
        renderProps(style.getSelector(), props);
    }
  }
  
  function renderProps(selector:String, styles:Array<VStyle>):String {
    var out = [];
    var def:Array<String> = [];

    function applySelector(suffix:String) {
      return selector != null
        ? selector + suffix
        : suffix;
    }

    function process(styles:Array<VStyle>) {
      for (s in styles) if (s != null) switch s {
        case VNone | null:

        case VRaw(value):
          if (selector != null)
            out.push('${selector} { ${value} }');
          else
            out.push(value);

        case VGlobal(styles):
          out.push(renderProps(null, styles));  
        
        case VProperty(name, value, important):
          if (important == true)
            def.push('${name}: ${value} !important;');
          else
            def.push('${name}: ${value};');

        case VChild(name, styles):
          out.push(renderProps(applySelector(' ${name}'), styles));

        case VChildren(styles):
          process(styles);
        
        case VPsuedo(type, styles):
          out.push(renderProps(applySelector(type), styles));

        case VMedia(mediaSelector, styles):
          out.push('@media ${mediaSelector} { ${renderProps(selector, styles)}  }');
      }
    }

    process(styles);

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
