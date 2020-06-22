package blok.core;

// @todo: change the way we pass Context around? Should it only
//        be set once, on Component creation?
@:allow(blok.core.Differ)
@:autoBuild(blok.core.ComponentBuilder.build())
class Component {

  @:noCompletion public var __alive:Bool = true;
  @:noCompletion public var __dirty:Bool = false;
  @:noCompletion public var __inserted:Bool = false;
  @:noCompletion var __context:Context;
  @:noCompletion var __pendingChildren:Array<Wire> = [];
  @:noCompletion var __rendered:Rendered;
  @:noCompletion var __parent:Wire;
  @:noCompletion var __nodes:Array<Node>;

  public inline function getCurrentContext() {
    return __context;
  }

  public function render(context:Context):VNode {
    return null;
  }

  @:noCompletion
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
  public function __update(props:Dynamic, context:Context, parent:Wire) {
    if (!__shouldUpdate(props)) {
      return;
    }

    __context = context;
    __parent = parent;

    __updateProps(props);
    __render(__context);
  }

  @:noCompletion
  public function __render(context:Context) {
    var engine = context.engine;
    var differ = engine.differ;
    
    if (!__alive) {
      #if debug
        throw 'Attempted to render a component that was dismounted';
      #end
      return;
    }

    __preRender();

    switch __rendered {
      case null:
        __rendered = differ.renderAll(
          __processRender(context),
          this,
          context
        );
      case before:
        var previousCount = 0;
        var first:Node = null;

        __rendered = differ.updateAll(
          before,
          __processRender(context),
          this,
          context
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
  inline function __preRender() {
    __dirty = false;
    __nodes = null;
    __pendingChildren = [];
    __registerEffects();
  }

  @:noCompletion
  public function __registerEffects() {
    // void
  }

  @:noCompletion
  inline function __processRender(context:Context) {
    return switch render(context) {
      case null | VFragment([], _): [ context.engine.placeholder(this) ];
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
      Helpers.later(() -> {
        __render(__context);
        __context.dispatchEffects();
      });
    } else {
      __parent.__enqueuePendingChild(this);
    }
  }

  @:noCompletion
  public function __enqueuePendingChild(child:Wire) {
    if (__dirty) return;
    if (__pendingChildren.indexOf(child) < 0) {
      __pendingChildren.push(child);
    }
    if (__parent != null) {
      __parent.__enqueuePendingChild(this);
    } else {
      Helpers.later(() -> {
        __dequeuePendingChildren();
        __context.dispatchEffects();
      });
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
          child.__render(__context);
        } else {
          child.__dequeuePendingChildren();
        }
      }
    }
  }

}
