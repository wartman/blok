package blok.core;

enum VNode {
  VWidget<Props:{}>(type:WidgetType<Props>, props:Props, ?key:Null<Key>);
  VFragment(children:Array<VNode>, ?key:Null<Key>);
}
