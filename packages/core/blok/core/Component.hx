package blok.core;

using blok.core.RenderedTools;

class Component<Node> {
  public var __alive:Bool = true;
  public var __dirty:Bool = false;
  public var __inserted:Bool = false;

  var __nodes:Array<Dynamic> = [];
  var __rendered:Rendered<Node>;
  var __context:Context<Node>;
  var __pendingChildren:Array<Component<Node>> = [];
  var __parent:Null<Component<Node>>;

  public inline function getCurrentContext() {
    return __context;
  }

  public function render(context:Context<Node>):VNode<Node> {
    return null;
  }

  public function __registerContext(context:Context<Node>) {
    this.__context = context;
  }

  public function __update(props:Dynamic, context:Context<Node>, parent:Component<Node>) {
    if (!__shouldUpdate(props)) {
      return;
    }

    __registerContext(context);
    __parent = parent;

    __updateProps(props);
    __render(this.__context);
  }

  public function __render(context:Context<Node>) {
    var engine = context.engine;

    __preRender();

    switch __rendered {
      case null:
        __rendered = Differ.renderAll(__processRender(context), this, context);
      case before:
        var previousCount = 0;
        var first:Node = null;

        __rendered = Differ.updateAll(before, __processRender(context), this, context);

        for (node in before.getNodes()) {
          if (first == null) first = node;
          previousCount++;
        }

        if (first != null) {
          Differ.setChildren(previousCount, engine.traverseSiblings(first), __rendered);
        }
    }
  }

  inline function __processRender(context:Context<Node>):Array<VNode<Node>> {
    return switch render(context) {
      case null | VFragment([], _): [context.engine.createPlaceholder({ component: this })];
      case VFragment(children, _): children;
      case node: [node];
    }
  }

  function __preRender() {
    if (!__alive) {
      #if debug
      throw 'Attempted to render a component that was dismounted';
      #end
    }
    __dirty = false;
    __nodes = null;
    __pendingChildren = [];
    __registerEffects();
  }

  public function __dispose() {
    if (__rendered != null) __rendered.dispose(__context);
    __alive = false;
    __parent = null;
    __pendingChildren = [];
    __context = null;
    __rendered = null;
  }
  
  function __updateProps(_:Dynamic) {
    // noop
  }

  function __shouldUpdate(_:Dynamic):Bool {
    // todo: only update if dirty?
    return true;
  }

  function __registerEffects() {
    // noop
  }
  
  function __requestUpdate() {
    if (__dirty) return;
    __dirty = true;
  
    // The idea here is that we're making sure that we never render things
    // more than once in a component tree every update.
    //
    // Probably needs some testing, but that's why all this logic is here.
    if (__parent == null) {
      Delay.add(() -> __context.scope(__render));
    } else {
      __parent.__enqueuePendingChild(this);
    }
  }

  public function __enqueuePendingChild(child:Component<Node>) {
    if (__dirty || __pendingChildren.contains(child)) return;
    
    __pendingChildren.push(child);

    if (__parent != null) {
      __parent.__enqueuePendingChild(this);
    } else {
      Delay.add(() -> __context.scope(__dequeuePendingChildren));
    }
  }

  public function __dequeuePendingChildren(parentContext:Context<Node>) {
    if (__pendingChildren.length == 0) return;
    var children = __pendingChildren.copy();

    __registerContext(parentContext); // not sure if this is needed?
    __pendingChildren = [];

    for (child in children) {
      if (child.__alive) {
        if (child.__dirty) {
          child.__render(__context);
        } else {
          child.__dequeuePendingChildren(__context);
        }
      }
    }
  }
}
