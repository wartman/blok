package blok;

class TextType {
  public static function create(props:{ content:String }, context:Context):Node {
    var n = new Node('#text');
    n.textContent = props.content;
    return n;
  }

  public static function update(node:Node, previousProps:{ content:String },  props:{ content:String }, context:Context):Node {
    if (previousProps.content != props.content) {
      node.textContent = props.content;
    }
    return node;
  }
}
