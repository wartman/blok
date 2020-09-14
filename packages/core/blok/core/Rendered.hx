package blok.core;

import haxe.ds.Map;

typedef Rendered<Node> = {
  public var types:Map<{}, TypeRegistry<Node>>;
  public var children:Array<RNode<Node>>;
}
