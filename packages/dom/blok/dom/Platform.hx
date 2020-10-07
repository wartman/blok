package blok.dom;

import js.html.Node;
import js.html.Element;
import blok.core.VNode;

class Platform {
  inline public static function createContext(?plugins) {
    return new blok.core.Context(new Engine(), null, plugins);
  }

  public static function mount(el:Element, factory:(context:Context)->VNode<Node>) {
    el.innerHTML = '';
    var context = createContext();
    context.render(el, factory);
  }

  public static function mountWithPlugins(el:Element, factory:(context:Context)->VNode<Node>, plugins) {
    el.innerHTML = '';
    var context = createContext(plugins);
    context.render(el, factory);
  }
}
