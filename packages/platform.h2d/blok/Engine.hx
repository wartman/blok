package blok;

import h2d.Object;
import blok.core.Cursor;
import blok.core.Rendered;
import blok.core.Component;
import blok.core.VNode;

class Engine implements blok.core.Engine<Object, Dynamic> {
  final renderedRegistry:Map<Object, Rendered<Object>> = [];
  
  public function new() {}
  
	public function traverseSiblings(target:Object):Cursor<Object> {
    return new blok.Cursor(target.parent, target.getChildIndex(target));
  }

	public function traverseChildren(parent:Object):Cursor<Object> {
    return new blok.Cursor(parent, 0);
  }

	public function getRendered(node:Object):Null<Rendered<Object>> {
    return renderedRegistry.get(node);
  }

	public function setRendered(node:Object, rendered:Null<Rendered<Object>>):Void {
    renderedRegistry.set(node, rendered);
  }

  public function createPlaceholder(props:{
    component:Component<Object>
  }):VNode<Object> {
    return VNative(ObjectType.empty(), props);
  }
}