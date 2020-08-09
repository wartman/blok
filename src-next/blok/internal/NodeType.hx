package blok.internal;

typedef NodeType<Props:{}, Node> = {
  public function create(props:Props, context:Context<Node>):Node;
  public function update(node:Node, previousProps:Props,  props:Props, context:Context<Node>):Node;
}
