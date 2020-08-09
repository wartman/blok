package blok.h2d;

import h2d.Object;
import blok.internal.Differ;
import blok.internal.Context;
import blok.internal.Component;
import blok.internal.Style;
import blok.internal.StyleList;
import blok.internal.VNode;

class Engine implements blok.internal.Engine<Object> {
  public final differ:Differ<Object>;
  
  public function new() {
    this.differ = new Differ();
  }
  
	public function createPlaceholder(target:Component<Object>):VNode<Object> {
    
  }

	public function traverseSiblings(first:Object):Cursor<Object> {

  }

	public function traverseChildren(parent:Object):Cursor<Object> {

  }

	public function getRendered(node:Object):Null<Rendered<Object>> {

  }

	public function setRendered(node:Object, rendered:Null<Rendered<Object>>):Void {

  }

	public function registerStyle(style:Style):Void {

  }

	public function applyStyles(node:Object, style:StyleList):Void {
    
  }
}