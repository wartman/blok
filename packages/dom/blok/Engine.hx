package blok;

import js.html.Node;
import js.html.Event;
import blok.core.Rendered;
import blok.html.Html;

using StringTools;

class Engine implements blok.core.Engine<Node, Event> {
  static inline final RENDERED_PROP = '__blok_rendered';

  public function new() {}

  public function traverseSiblings(first:Node):Cursor {
    return new Cursor(first.parentNode, first);
  }

  public function traverseChildren(parent:Node):Cursor {
    return new Cursor(parent, parent.firstChild);
  }

  public function getRendered(node:Node):Null<Rendered<Node>> {
    return Reflect.field(node, RENDERED_PROP);
  }

  public function setRendered(node:Node, rendered:Null<Rendered<Node>>):Void {
    Reflect.setField(node, RENDERED_PROP, rendered);
  }

  public function createPlaceholder(props:{
    component:blok.core.Component<Node>
  }):VNode {
    return Html.text('');
  }
}
