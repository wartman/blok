package blok;

import h2d.Object;
import blok.core.Differ;
import blok.core.Cursor;
import blok.core.Context;
import blok.core.Rendered;
import blok.core.Component;
import blok.core.Style;
import blok.core.StyleList;
import blok.core.VNode;

class Engine implements blok.core.Engine<Object> {
  final renderedRegistry:Map<Object, Rendered<Object>> = [];
  
  public function new() {}
  
	public function createPlaceholder(target:Component<Object>):VNode<Object> {
    return VNative(ObjectType.empty(), {});
  }

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

	public function registerStyle(style:Style):Void {

  }

	public function applyStyles(node:Object, style:StyleList):Void {
    
  }
}