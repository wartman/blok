package blok;

import js.html.Node;
import js.html.Event;
import blok.core.Rendered;
import blok.core.StyleList;
import blok.dom.Html;
import blok.ui.style.BaseStyle;

using StringTools;

class Engine implements blok.core.Engine<Node, Event> {
  static inline final RENDERED_PROP = '__blok_rendered';

  final css = new CssEngine();

  public function new(useBaseStyle = true) {
    if (useBaseStyle) {
      var base = new BaseStyle({});
      @:privateAccess css.addCss(null, base.render());
    }
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

  public function createContainer(props:{
    ?style:StyleList,
    ?children:Array<VNode>
  }):VNode {
    return Html.div({
      style: props.style,
      children: props.children
    });
  }

  public function createButton(props:{
    ?style:StyleList,
    ?onClick:(e:Event)->Void,
    // etc
    ?children:Array<VNode>
  }):VNode {
    return Html.button({
      style: props.style,
      attrs: {
        onclick: props.onClick
      },
      children: props.children
    });
  }

  public function createPlaceholder(props:{
    component:blok.core.Component<Node>
  }):VNode {
    return Html.text('');
  }
}
