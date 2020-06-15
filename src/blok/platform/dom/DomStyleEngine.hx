package blok.platform.dom;

import js.Browser;
import js.html.CSSStyleSheet;
import blok.core.StyleEngine;
import blok.style.BaseStyle;

class DomStyleEngine implements StyleEngine {

  final sheet:CSSStyleSheet;
  final defined:Map<String, Bool> = [];
  final indices:Map<String, Int> = [];

  public function new() {
    var el = Browser.document.createStyleElement();
    
    Browser.document.head.appendChild(el);
    sheet = cast el.sheet;

    // Todo: There may be a better place for this?
    define(BaseStyle.id, () -> BaseStyle.get().render());
  }

  public function exists(name:String):Bool {
    return defined[name] == true;
  }

  public function define(name:String, css:()->String):Void {
    if (!defined[name]) {
      add(name, css());
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

}
