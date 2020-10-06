package blok;

import js.html.Node;
import js.html.Event;
import blok.core.Rendered;
import blok.core.StyleList;
import blok.core.Style;
import blok.html.Html;

using StringTools;

class Engine implements blok.core.Engine<Node, Event> {
  static inline final RENDERED_PROP = '__blok_rendered';

  final css = new CssEngine();

  public function new(useBaseStyle = true) {
    if (useBaseStyle) registerBaseStyle();
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

  public function applyStyles(node:Node, style:StyleList):Void {
    css.apply(node, style);
  }

  public function createPlaceholder(props:{
    component:blok.core.Component<Node>
  }):VNode {
    return Html.text('');
  }

  inline function registerBaseStyle() {
    @:privateAccess css.addCss(null, [
      Style.global([
        Style.raw('
          body, html {
            padding: 0;
            margin: 0;
          }
          
          html {
            box-sizing: border-box;
          }
          
          *, *:before, *:after {
            box-sizing: inherit;
          }
          
          ul, ol, li {
            margin: 0;
            padding: 0;
          }
          
          ul, ol {
            list-style: none;
          }
        ')
      ])
    ]);
  }
}
