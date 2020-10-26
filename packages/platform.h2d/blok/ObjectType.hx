package blok;

import h2d.Object;
import blok.core.Context;
import blok.core.Differ;

class ObjectType<Props:{}> {
  static var __empty:ObjectType<Dynamic>;
  
  public static function empty<Props:{}>():ObjectType<Props> {
    if (__empty == null) {
      __empty = new ObjectType(_ -> new Object());
    }
    return cast __empty;
  }

  final factory:(props:Props)->Object;

  public function new(factory) {
    this.factory = factory;
  }

	public function create(props:Props, context:Context<Object>):Object {
    var node = factory(props);
    // Differ.diffObject({}, props, applyProperty.bind(node));
    return node;
  }

  public function update(node:Object, previousProps:Props, props:Props, context:Context<Object>):Object {
    Differ.diffObject(previousProps, props, applyProperty.bind(node));
    return node;
  }

  function applyProperty(node:Object, name:String, oldValue:Dynamic, newValue:Dynamic) {
    Reflect.setProperty(node, name, newValue);
  }
}
