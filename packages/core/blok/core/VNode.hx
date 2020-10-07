package blok.core;

enum VNode<Node> {
  VNative<Props:{}>(
    type:NodeType<Props, Node>,
    props:Props,
    ?plugables:Array<PluginPayload<Dynamic>>,
    ?ref:(node:Node)->Void, 
    ?key:Null<Key>, 
    ?children:Array<VNode<Node>>
  );
  VComponent<Props:{}>(
    type:ComponentType<Props, Node>,
    props:Props, 
    ?key:Null<Key>
  );
  VFragment(children:Array<VNode<Node>>, ?key:Null<Key>);
}
