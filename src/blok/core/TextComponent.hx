package blok.core;

class TextComponent extends Component {

  @prop var content:String;
  var prevContent:String = null;
  var realNode:Node;

  override function __getManagedNodes():Array<Node> {
    if (realNode == null) __createNode(__context);
    return [ realNode ];
  }

  function __createNode(context:Context):Node {
    var engine = context.engine;
    realNode = engine.createTextNode(this.content);
    return realNode;
  }

  override function __render(context:Context) {
    if (realNode == null) __createNode(context);
    if (prevContent != content) {
      prevContent = content;
      context.engine.updateTextNode(realNode, content);
    }
  }

}
