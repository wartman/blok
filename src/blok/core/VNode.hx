package blok.core;

enum VNode {
  VWire<Props:{}>(type:WireType<Props>, props:Props, ?key:Null<Key>);
  VFragment(children:Array<VNode>, ?key:Null<Key>);
}
