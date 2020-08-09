package blok.ui;

import js.html.Node;
import js.html.Element;
import blok.internal.VNode;

class Platform {
  
  inline public static function createContext() {
    return new blok.internal.Context(new Engine());
  }

  public static function mount(el:Element, factory:(context:Context)->VNode<Node>) {
    el.innerHTML = '';
    var context = createContext();
    context.engine.differ.render(el, [ factory(context) ], null, context);
    // effects?
  }

}
