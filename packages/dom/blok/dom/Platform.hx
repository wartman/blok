package blok.dom;

import js.html.Node;
import js.html.Element;
import blok.core.VNode;

class Platform {
  inline public static function createContext() {
    return new blok.core.Context(new Engine());
  }

  public static function mount(el:Element, factory:(context:Context)->VNode<Node>) {
    el.innerHTML = '';
    var context = createContext();
    context.render(el, factory);
  }
}
