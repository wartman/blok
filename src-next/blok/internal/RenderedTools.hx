package blok.internal;

@:access(blok.internal.Component)
class RenderedTools {
  public static function getNodes<Node>(rendered:Rendered<Node>):Array<Node> {
    var nodes:Array<Node> = [];
    for (r in rendered.children)
      switch r {
        case RNative(node, _):
          nodes.push(node);
        case RComponent(child):
          nodes = nodes.concat(getNodes(child.__rendered));
      }
    return nodes;
  }
}
