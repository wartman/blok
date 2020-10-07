package blok.core;

interface Plugin<Node> {
  public function onCreate(content:Context<Node>, vnode:VNode<Node>):Void;
  public function onUpdate(content:Context<Node>, vnode:VNode<Node>):Void;
}
