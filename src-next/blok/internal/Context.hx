package blok.internal;

import haxe.ds.Map;

class Context<Node> {
  public final engine:Engine<Node>;

  final data:Map<String, Dynamic> = [];
  final parent:Context<Node>;

  public function new(engine, ?parent) {
    this.engine = engine;
    this.parent = parent;
  }

  public function get<T>(name:String, ?def:T):T {
    if (parent == null) {
      return data.exists(name) ? data.get(name) : def; 
    }
    return switch [ data.get(name), parent.get(name) ] {
      case [ null, null ]: def;
      case [ null, res ]: res;
      case [ res, _ ]: res;
    }
  }

  public function set<T>(name:String, value:T) {
    data.set(name, value);
  }

  public function getChild() {
    return new Context(engine, this);
  }
}
