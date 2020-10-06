package blok.statik;

class Platform {
  inline public static function createContext() {
    return new blok.core.Context(new Engine());
  }

  public static function render(factory:(context:Context)->VNode):String {
    var ctx = createContext();
    var root = new Node('#document'); 
    ctx.render(root, factory);
    return root.toString();
  }
}
