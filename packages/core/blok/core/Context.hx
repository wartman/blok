package blok.core;

import haxe.ds.Map;

/**
  Context stores the current state of an app.
**/
class Context<Node> {
  public final engine:Engine<Node, Dynamic>;

  final data:Map<String, Dynamic> = [];
  final parent:Context<Node>;

  var effectQueue:Array<()->Void> = [];

  public function new(engine, ?parent) {
    this.engine = engine;
    this.parent = parent;
  }

  /**
    Render to the given `node` using whatever underlying engine this
    context uses. Usually where you'll bootstrap an app.
  **/
  public function render(node:Node, factory:(context:Context<Node>)->VNode<Node>) {
    scope(ctx -> Differ.render(
      node,
      [ factory(ctx) ],
      null,
      ctx
    ));
  }

  /**
    Handle a callback and fire off any effects when done.

    This is probably not the best way to handle effects, but it was simple
    to quickly implement.
  **/
  public inline function scope(cb:(context:Context<Node>)->Void) {
    clearEffects();
    cb(this);
    dispatchEffects();
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
    if (parent != null) {
      parent.clearEffects();
      return;
    }
    effectQueue = [];
  }
}
