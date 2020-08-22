package blok.core;

@:access(blok.core.Component)
class RenderedTools {
  public static function getNodes<Node>(rendered:Rendered<Node>):Array<Node> {
    var nodes:Array<Node> = [];
    if (rendered == null) return [];
    for (r in rendered.children)
      switch r {
        case RNative(node, _):
          nodes.push(node);
        case RComponent(child):
          nodes = nodes.concat(getNodes(child.__rendered));
      }
    return nodes;
  }

  public static function dispose<Node>(rendered:Rendered<Node>, context:Context<Node>) {
    for (r in rendered.types) r.each(item -> switch item {
      case RComponent(component):
        component.__dispose();
      case RNative(node, _):
        var sub = context.engine.getRendered(node);
        if (sub != null) dispose(sub, context);
    });
  }
}
