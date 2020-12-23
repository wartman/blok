package blok;

import blok.core.Rendered;
import blok.core.html.Html;

class Engine implements blok.core.Engine<Node, Dynamic> {
  public function new() {}

  public function traverseSiblings(first:Node):Cursor {
    return new Cursor(first.parentNode, first);
  }

  public function traverseChildren(parent:Node):Cursor {
    return new Cursor(parent, parent.childNodes[0]);
  }

  public function getRendered(node:Node):Null<Rendered<Node>> {
    return node.rendered;
  }

  public function setRendered(node:Node, rendered:Null<Rendered<Node>>):Void {
    node.rendered = rendered;
  }

  public function createPlaceholder(component:blok.core.Component<Node>):VNode {
    return Html.text('');
  }
}
