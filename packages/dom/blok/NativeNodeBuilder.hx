package blok;

import js.html.Event;
import js.html.Node;
import blok.core.StyleList;
import blok.dom.Html;

class NativeNodeBuilder implements blok.core.NativeNodeBuilder<Node, Event> {
  public function new() {}

  public function container(props:{
    ?style:StyleList,
    ?children:Array<VNode>
  }):VNode {
    return Html.div({
      style: props.style,
      children: props.children
    });
  }

  public function button(props:{
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

  public function placeholder(props:{
    component:blok.core.Component<Node>
  }):VNode {
    return Html.text('');
  }
}
