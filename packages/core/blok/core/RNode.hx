package blok.core;

enum RNode<Node> {
  RNative<Props:{}>(node:Node, props:Props);
  RComponent<Props:{}>(component:Component<Node>);
}
