package blok;

import js.Browser;
import js.html.Node;
import js.html.Text;

class TextType {

  public static function updateTextNode(node:Node, content:String):Void {
    switch Std.downcast(node, Text) {
      case null:
      case text:
        text.textContent = content;
    }
  }

  public static function create(props:{ content:String }, context:Context):Node {
    return Browser.document.createTextNode(props.content);
  }

  public static function update(node:Node, previousProps:{ content:String },  props:{ content:String }, context:Context):Node {
    if (previousProps.content != props.content) {
      updateTextNode(node, props.content);
    }
    return node;
  }

}
