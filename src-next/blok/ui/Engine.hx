package blok.ui;

import js.html.Node;
import blok.internal.Differ;
import blok.internal.VNode;
import blok.internal.Rendered;
import blok.internal.Style;
import blok.internal.StyleList;

class Engine implements blok.internal.Engine<Node> {
  static inline final RENDERED_PROP = '__blok_rendered';

  public final differ:Differ<Node>;

  public function new() {
    differ = new Differ();
  }

  public function createPlaceholder(target:blok.internal.Component<Node>):VNode<Node> {
    return Html.text('');
  }

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

  public function registerStyle(style:Style):Void {
    // todo
  }

  public function applyStyles(node:Node, style:StyleList):Void {
    // todo
  }
}
