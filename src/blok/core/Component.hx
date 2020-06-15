package blok.core;

@:autoBuild(blok.core.ComponentBuilder.build())
@:allow(blok.core.Differ)
class Component {

  public var __alive:Bool = true;
  public var __dirty:Bool = false;
  public var __inserted:Bool = false;
  var __context:Context;
  var __pendingChildren:Array<Widget> = [];
  var __rendered:Rendered;
  var __parent:Widget;
  var __nodes:Array<Node>;

  public function render(context:Context):VNode {
    return null;
  }

  public function __getManagedNodes():Array<Node> {
    if (__rendered == null) return [];
    if (__nodes == null) {
      var nodes:Array<Node> = [];
      for (widget in __rendered.children) {
        nodes = nodes.concat(widget.__getManagedNodes());
      }
      __nodes = nodes;
    }
    return __nodes;
  }

  @:noCompletion
  public function __update(props:Dynamic, context:Context, parent:Widget) {
    if (!__shouldUpdate(props)) {
      return;
    }

    __context = context;
    __parent = parent;

    __updateProps(props);
    __doRender();
  }

  @:noCompletion
  public function __doRender() {
    var engine = __context.engine;
    var differ = engine.differ;
    
    __dirty = false;
    __nodes = null;
    __pendingChildren = [];

    switch __rendered {
      case null:
        __rendered = differ.renderAll(
          __processRender(),
          this,
          __context
        );
      case before:
        var previousCount = 0;
        var first:Node = null;

        for (node in __getManagedNodes()) {
          if (first == null) first = node;
          previousCount++;
        };

        __rendered = differ.updateAll(
          before,
          __processRender(),
          this,
          __context
        );

        if (first != null) differ.setChildren(
          previousCount,
          engine.traverseSiblings(first),
          __rendered
        );
    }
  }

  @:noCompletion
  inline function __processRender() {
    return switch render(__context) {
      case null | VFragment([], _): [ __context.engine.placeholder(this) ];
      case VFragment(children, _): children;
      case node: [ node ];
    }
  }

  @:noCompletion
  function __updateProps(_:Dynamic) {
    // noop
  }

  @:noCompletion
  function __shouldUpdate(_:Dynamic):Bool {
    // todo: only update if dirty?
    return true;
  }

  @:noCompletion
  public function __dispose() {
    __alive = false;
    __context = null;
    __parent = null;
    __pendingChildren = [];
  }

  @:noCompletion
  function __requestUpdate() {
    if (__dirty) return;

    if (__parent == null) {
      // todo: effect queue
      Helpers.later(() -> __doRender());
    } else {
      __dirty = true;
      __parent.__enqueuePendingChild(this);
    }
  }

  @:noCompletion
  public function __enqueuePendingChild(child:Widget) {
     if (__pendingChildren.indexOf(child) < 0) {
      __pendingChildren.push(child);
    }
    if (__parent != null) {
      __parent.__enqueuePendingChild(this);
    } else {
      Helpers.later(() -> __dequeuePendingChildren());
    }
  }

  @:noCompletion
  public function __dequeuePendingChildren() {
    if (__pendingChildren.length == 0) return;
    var children = __pendingChildren.copy();

    __pendingChildren = [];

    for (child in children) {
      if (child.__alive) {
        if (child.__dirty) {
          child.__doRender();
        } else {
          child.__dequeuePendingChildren();
        }
      }
    }
  }

}
