package blok.internal;

import haxe.ds.Map;

typedef Rendered<Node> = {
	public var types:Map<ComponentType<Dynamic, Node>, TypeRegistry<Node>>;
	public var children:Array<RNode<Node>>;
}
