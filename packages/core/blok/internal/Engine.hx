package blok.internal;

interface Engine<Node> {
  final differ:Differ<Node>;
  public function createPlaceholder(target:Component<Node>):VNode<Node>;
  public function traverseSiblings(first:Node):Cursor<Node>;
  public function traverseChildren(parent:Node):Cursor<Node>;
  public function getRendered(node:Node):Null<Rendered<Node>>;
  public function setRendered(node:Node, rendered:Null<Rendered<Node>>):Void;
  public function registerStyle(style:Style):Void;
  public function applyStyles(node:Node, style:StyleList):Void;
}
