package blok.core;

/**
  A standard set of native node builders to allow a degree of
  cross-platform compatability.
  
  Each platform should implement this.
**/
interface NativeNodeBuilder<Node, Event> {
  public function container(props:{
    ?style:StyleList,
    ?children:Array<VNode<Node>>
  }):VNode<Node>;
  public function button(props:{
    ?style:StyleList,
    ?onClick:(e:Event)->Void,
    // etc
    ?children:Array<VNode<Node>>
  }):VNode<Node>;
  // todo: also add Lists and Text and the like?
  public function placeholder(props:{
    component:Component<Node>
  }):VNode<Node>;
}
