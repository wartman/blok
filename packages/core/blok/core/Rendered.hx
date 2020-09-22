package blok.core;

import haxe.ds.Map;

@:structInit
@:access(blok.core.Component)
class Rendered<Node> {
  public final types:Map<{}, TypeRegistry<Node>>;
  public final children:Array<RNode<Node>>;

  public function getNodes():Array<Node> {
    var nodes:Array<Node> = [];
    for (r in children)
      switch r {
        case RNative(node, _):
          nodes.push(node);
        case RComponent(child):
          nodes = nodes.concat(child.__rendered.getNodes());
      }
    return nodes;
  }

  public function dispose(context:Context<Node>) {
    for (r in types) r.each(item -> switch item {
      case RComponent(component):
        component.__dispose();
      case RNative(node, _):
        var sub = context.engine.getRendered(node);
        if (sub != null) sub.dispose(context);
    });
  }
}
