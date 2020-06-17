package blok.core;

final class NodeComponent<Attrs:{}> extends Component {

  @prop var tag:String;
  @prop var children:Array<VNode> = null;
  @prop var attrs:Attrs = null;
  @prop var key:Key = null;
  @prop var style:VStyleList = null;
  @prop var ref:(node:Node)->Void = null;
  var prevAttrs:Attrs = null;
  var realNode:Node;

  override function __getManagedNodes():Array<Node> {
    if (realNode == null) __createNode();
    return [ realNode ];
  }

  function __createNode():Node {
    if (realNode != null) {
      return realNode;
    }

    var engine = __context.engine;
    realNode = engine.createNode(tag);
    return realNode;
  }

  function __updateNodeAttrs() {
    var engine = __context.engine;
    var styleEngine = __context.styleEngine;

    if (style != null) {
      for (s in style) styleEngine.define(s.getName(), s.render);

      if (attrs == null) __props.attrs = cast {};

      var existing:String = Reflect.field(attrs, 'className');
      Reflect.setField(
        attrs,
        'className',
        if (existing == null) 
          style.toString()
        else
          style.toString() + ' ' + existing
      );
    }

    engine.differ.diffObject(
      if (prevAttrs == null) cast {} else prevAttrs, 
      attrs, 
      engine.updateNodeAttr.bind(realNode)
    );
    prevAttrs = attrs;
  }

  override function __render() {
    var engine = __context.engine;
    var differ = engine.differ;
    var previousCount = 0;

    if (realNode == null) __createNode();
    __updateNodeAttrs();
    __preRender();

    switch __rendered {
      case null:
        __rendered = differ.renderAll(
          __processRender(),
          this,
          __context
        );
      case before:
        __rendered = differ.updateAll(
          before,
          __processRender(),
          this,
          __context
        );

        for (child in before.children) {
          previousCount += child.__getManagedNodes().length;
        }
    }

    differ.setChildren(
      previousCount,
      engine.traverseChildren(realNode),
      __rendered
    );

    if (ref != null) ref(realNode);
  }

  override function render(context:Context):VNode {
    return if (children != null) VFragment(children, key) else null;
  }

}
