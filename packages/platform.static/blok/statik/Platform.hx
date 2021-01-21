package blok.statik;

class Platform {
  inline public static function createContext() {
    return new blok.core.Context(new Engine());
  }

  public static function mount(root:Node, factory:(context:Context)->VNode) {
    var ctx = createContext();
    ctx.render(root, factory);
  }

  public static function render(factory:(context:Context)->VNode):String {
    var root = new Node('#document'); 
    mount(root, factory);
    return root.toString();
  }
}
