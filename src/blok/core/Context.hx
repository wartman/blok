package blok.core;

class Context {

  public final engine:Engine;
  public final styleEngine:StyleEngine;
  final data:Map<String, Dynamic> = [];
  final parent:Context;
  var effectQueue:Array<()->Void> = [];

  public function new(engine, styleEngine, ?parent:Context) {
    this.engine = engine;
    this.styleEngine = styleEngine;
    this.parent = parent;
  } 
  
  public function getChild() {
    return new Context(engine, styleEngine, this);
  }

  public function get<T>(name:String, ?def:T):T {
    return if (data.exists(name)) 
      data.get(name)
    else if (parent != null)
      parent.get(name, def); 
    else 
      def;
  }

  public function set<T>(name:String, value:T) {
    data.set(name, value);
  }

  public function addEffect(effect:()->Void) {
    if (parent != null) {
      parent.addEffect(effect);
      return;
    }
    effectQueue.unshift(effect);
  }

  public function dispatchEffects() {
    if (parent != null) {
      parent.dispatchEffects();
      return;
    }
    var toDispatch = effectQueue.copy();
    effectQueue = [];
    for (e in toDispatch) e();
  }

  public function clearEffects() {
    effectQueue = [];
  }
  
}
