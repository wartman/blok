package blok.core;

class Component<Node> {
  public var __alive:Bool = true;
  public var __dirty:Bool = false;
  public var __inserted:Bool = false;

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
    __render();
  }

  public function __render() {
    __preRender();

    switch __rendered {
      case null:
        Differ.renderAll(
          __processRender(), 
          this, 
          __context,
          rendered -> __rendered = rendered
        );
      case before:
        var previousCount = 0;
        var first:Node = null;

        Differ.updateAll(
          before, 
          __processRender(), 
          this, 
          __context,
          rendered -> {
            __rendered = rendered;
            
            for (node in before.getNodes()) {
              if (first == null) first = node;
              previousCount++;
            }

            Differ.setChildren(previousCount, __context.engine.traverseSiblings(first), __rendered);
          }
        );
    }
  }

  inline function __processRender():Array<VNode<Node>> {
    return switch render(__context) {
      case null | VFragment([], _): [__context.engine.createPlaceholder(this)];
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
      Delay.add(() -> __context.scope(_ -> __render()));
    } else {
      __parent.__enqueuePendingChild(this);
    }
  }

  public function __enqueuePendingChild(child:Component<Node>) {
    if (__dirty || __pendingChildren.contains(child)) return;
    
    __pendingChildren.push(child);

    if (__parent == null) {
      Delay.add(() -> __context.scope(_ -> __dequeuePendingChildren()));
    } else {
      __parent.__enqueuePendingChild(this);
    }
  }

  public function __dequeuePendingChildren() {
    if (__pendingChildren.length == 0) return;
    var children = __pendingChildren.copy();

    __pendingChildren = [];

    for (child in children) {
      if (child.__alive) {
        if (child.__dirty) {
          // @todo: there might be instances where Context gets out
          //        of sync here? We might look into that.
          //        HOWEVER: I think we need to rethink our Context
          //        system a bit anyway.
          child.__render();
        } else {
          child.__dequeuePendingChildren();
        }
      }
    }
  }
}
