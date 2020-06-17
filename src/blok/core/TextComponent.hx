package blok.core;

class TextComponent extends Component {

  @prop var content:String;
  var prevContent:String = null;
  var realNode:Node;

  override function __getManagedNodes():Array<Node> {
    if (realNode == null) __createNode();
    return [ realNode ];
  }

  function __createNode():Node {
    var engine = __context.engine;
    realNode = engine.createTextNode(this.content);
    return realNode;
  }

  override function __render() {
    if (realNode == null) __createNode();
    if (prevContent != content) {
      prevContent = content;
      __context.engine.updateTextNode(realNode, content);
    }
  }

}
