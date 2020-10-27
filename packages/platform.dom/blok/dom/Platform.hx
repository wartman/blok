package blok.dom;

import js.html.Node;
import js.html.Element;
import blok.core.VNode;

class Platform {
  inline public static function createContext(?plugins) {
    return new blok.core.Context(new Engine(), null, plugins);
  }

  /**
    The primary entry point for any app.
  
    This will include the default StylePlugin if the `blok.core.style` 
    library is preset.

    Use `mountWithPlugins` to provide a StylePlugin (or any other
    Plugin) with your own configuration.
  **/
  public static function mount(el, factory) {
    mountWithPlugins(el, factory, [ #if blok.core.style new StylePlugin({}) #end ]);
  }

  public static function mountWithPlugins(el:Element, factory:(context:Context)->VNode<Node>, plugins) {
    el.innerHTML = '';
    var context = createContext(plugins);
    context.render(el, factory);
  }

  /**
    Start an App *without* any plugins. Note that Styles WILL NOT
    work here unless you use a PluginProvider to register a StylePlugin.
  **/
  public static function mountWithoutPlugins(el:Element, factory:(context:Context)->VNode<Node>) {
    el.innerHTML = '';
    var context = createContext();
    context.render(el, factory);
  }
}
