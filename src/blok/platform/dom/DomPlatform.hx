package blok.platform.dom;

import js.html.Element;
import blok.core.VNode;
import blok.core.Context;

class DomPlatform {
  
  inline public static function createContext() {
    return new Context(new DomEngine());
  }

  public static function mount(el:Element, factory:(context:Context)->VNode) {
    el.innerHTML = '';
    var context = createContext();
    var differ = context.engine.differ;
    differ.render(cast el, [ factory(context) ], null, context);
    context.dispatchEffects();
  }

}
