package blok.core;

interface Engine {
  final differ:Differ;
  public function createNode(tag:String):Node;
  public function createSvgNode(tag:String):Node;
  public function createTextNode(content:String):Node;
  public function updateTextNode(node:Node, content:String):Void; 
  public function updateNodeAttr(node:Node, name:String, oldValue:Dynamic, newValue:Dynamic):Void;
  public function dangerouslySetInnerHtml(node:Node, html:String):Void;
  public function traverseSiblings(first:Node):Cursor;
  public function traverseChildren(parent:Node):Cursor;
  public function placeholder(target:Component):VNode;
	public function registerStyle(style:VStyleList):Void;
	public function applyStyle(node:Node, style:VStyleList):Void;
 }
