package blok.core;

interface Engine<Node, Event> {
  public final builder:NativeNodeBuilder<Node, Event>;
  public function traverseSiblings(first:Node):Cursor<Node>;
  public function traverseChildren(parent:Node):Cursor<Node>;
  public function getRendered(node:Node):Null<Rendered<Node>>;
  public function setRendered(node:Node, rendered:Null<Rendered<Node>>):Void;
  public function registerStyle(style:StyleList):Void;
  public function applyStyles(node:Node, style:StyleList):Void;
}
