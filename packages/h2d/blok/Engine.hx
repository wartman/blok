package blok;

import h2d.Object;
import blok.core.Cursor;
import blok.core.Rendered;
import blok.core.Component;
import blok.core.StyleList;
import blok.core.VNode;

class Engine implements blok.core.Engine<Object, Dynamic> {
  final renderedRegistry:Map<Object, Rendered<Object>> = [];
  final styleEngine = new StyleEngine();
  
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

	public function applyStyles(node:Object, style:StyleList):Void {
    styleEngine.apply(node, style);
  }

  // TODO: just trying to compile atm

  public function createContainer(props:{
    ?style:StyleList,
    ?children:Array<VNode<Object>>
  }):VNode<Object> {
    return VNative(ObjectType.empty(), props);
  }
  
  public function createButton(props:{
    ?style:StyleList,
    ?onClick:(e:Dynamic)->Void,
    // etc
    ?children:Array<VNode<Object>>
  }):VNode<Object> {
    return VNative(ObjectType.empty(), props);
  }

  public function createPlaceholder(props:{
    component:Component<Object>
  }):VNode<Object> {
    return VNative(ObjectType.empty(), props);
  }
}