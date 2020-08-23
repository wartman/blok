package blok.core;

interface Engine<Node, Event> {
  public function traverseSiblings(first:Node):Cursor<Node>;
  public function traverseChildren(parent:Node):Cursor<Node>;
  public function getRendered(node:Node):Null<Rendered<Node>>;
  public function setRendered(node:Node, rendered:Null<Rendered<Node>>):Void;
  public function applyStyles(node:Node, style:StyleList):Void;
  public function createContainer(props:{
    ?style:StyleList,
    ?children:Array<VNode<Node>>
  }):VNode<Node>;
  // public function createList(props:{
  //   ?style:StyleList,
  //   ?children:Array<VNode<Node>>
  // }):VNode<Node>;
  public function createButton(props:{
    ?style:StyleList,
    ?onClick:(e:Event)->Void,
    // etc
    ?children:Array<VNode<Node>>
  }):VNode<Node>;
  public function createPlaceholder(props:{
    component:Component<Node>
  }):VNode<Node>;
}