package blok.dom;

import js.html.Node;
import js.html.Element;
import blok.core.VNode;

class Platform {
  inline public static function createContext(useBaseStyle = true) {
    return new blok.core.Context(new Engine(), null, [
      // @todo: a better way to set this up
      new StylePlugin([], useBaseStyle)
    ]);
  }

  public static function mount(el:Element, factory:(context:Context)->VNode<Node>) {
    el.innerHTML = '';
    var context = createContext();
    context.render(el, factory);
  }

  public static function mountNoBaseStyle(el:Element, factory:(context:Context)->VNode<Node>) {
    el.innerHTML = '';
    var context = createContext(false);
    context.render(el, factory);
  }
}
