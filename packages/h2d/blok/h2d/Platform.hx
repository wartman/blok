package blok.h2d;

import h2d.Object;
import h2d.Scene;
import blok.core.VNode;

class Platform {
  inline public static function createContext() {
    return new blok.core.Context(new Engine());
  }

  public static function mount(scene:Scene, factory:(context:Context)->VNode<Object>) {
    var context = createContext();
    context.render(scene, factory);
  }
}
