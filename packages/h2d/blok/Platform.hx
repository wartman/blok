package blok;

import h2d.Object;
import h2d.Scene;
import blok.internal.VNode;

class Platform {
  inline public static function createContext() {
    return new blok.internal.Context(new Engine());
  }

  public static function mount(scene:Scene, factory:(context:Context)->VNode<Object>) {
    var context = createContext();
    context.render(scene, factory);
  }
}
