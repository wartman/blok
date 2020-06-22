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
    if (realNode == null) __createNode(__context);
    return [ realNode ];
  }

  function __createNode(context:Context):Node {
    if (realNode != null) {
      return realNode;
    }

    var engine = context.engine;
    realNode = engine.createNode(tag);
    return realNode;
  }

  function __updateStyle(context:Context) {
    var styleEngine = context.styleEngine;
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
  }

  function __updateNodeAttrs(context:Context) {
    var engine = context.engine;
    engine.differ.diffObject(
      if (prevAttrs == null) cast {} else prevAttrs, 
      attrs, 
      engine.updateNodeAttr.bind(realNode)
    );
    prevAttrs = attrs;
  }

  override function __render(context:Context) {
    var engine = context.engine;
    var differ = engine.differ;
    var previousCount = 0;

    if (realNode == null) __createNode(context);
    __updateStyle(context);
    __updateNodeAttrs(context);
    __preRender();

    switch __rendered {
      case null:
        __rendered = differ.renderAll(
          __processRender(context),
          this,
          context
        );
      case before:
        __rendered = differ.updateAll(
          before,
          __processRender(context),
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
