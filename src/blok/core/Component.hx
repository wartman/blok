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
    if (__nodes == null) {
      var nodes:Array<Node> = [];
      for (child in __rendered.children) {
        nodes = nodes.concat(child.__getManagedNodes());
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

    trace(Type.getClassName(Type.getClass(this)));
    trace(this);
    
    if (!__alive) {
      #if debug
        throw 'Attempted to render a component that was dismounted';
      #end
      return;
    }

    __dirty = false;
    __nodes = null;
    __pendingChildren = [];

    switch __rendered {
      case null:
        trace('New render');
        __rendered = differ.renderAll(
          __processRender(),
          this,
          __context
        );
      case before:
        var previousCount = 0;
        var first:Node = null;

        __rendered = differ.updateAll(
          before,
          __processRender(),
          this,
          __context
        );

        for (child in before.children) for (node in child.__getManagedNodes()) {
          if (first == null) first = node;
          previousCount++;
        };

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
    if (__rendered != null) {
      for (r in __rendered.types) r.each(c -> c.__dispose());
    }
  }

  @:noCompletion
  function __requestUpdate() {
    if (__dirty) return;
    __dirty = true;
    if (__parent == null) {
      Helpers.later(() -> __doRender());
    } else {
      __parent.__enqueuePendingChild(this);
    }
  }

  @:noCompletion
  public function __enqueuePendingChild(child:Widget) {
    if (__dirty) return;
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
