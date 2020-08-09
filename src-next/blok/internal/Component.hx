package blok.internal;

using blok.internal.RenderedTools;

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

	public function __update(props:Dynamic, context:Context<Node>, parent:Component<Node>) {
		if (!__shouldUpdate(props)) {
			return;
		}

		__context = context;
		__parent = parent;

		__updateProps(props);
		__render(__context);
	}

	public function __render(context:Context<Node>) {
		var engine = context.engine;
		var differ = engine.differ;

		__preRender();

		switch __rendered {
			case null:
				__rendered = differ.renderAll(__processRender(context), this, context);
			case before:
				var previousCount = 0;
				var first:Node = null;

				__rendered = differ.updateAll(before, __processRender(context), this, context);

				for (node in before.getNodes()) {
          if (first == null) first = node;
          previousCount++;
        }

				if (first != null) {
					differ.setChildren(previousCount, engine.traverseSiblings(first), __rendered);
        }
    }
  }

	inline function __processRender(context:Context<Node>):Array<VNode<Node>> {
		return switch render(context) {
			case null | VFragment([], _): [context.engine.createPlaceholder(this)];
			case VFragment(children, _): children;
			case node: [node];
		}
	}

	inline function __preRender() {
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
    __alive = false;
    __context = null;
    __parent = null;
    __pendingChildren = [];
    if (__rendered != null) {
      for (r in __rendered.types) r.each(r -> switch r { 
				case RComponent(c): c.__dispose();
				default:
			});
    }
  }
  
  function __updateProps(_:Dynamic) {
    // noop
  }

  function __shouldUpdate(_:Dynamic):Bool {
    // todo: only update if dirty?
    return true;
  }

	function __registerEffects() {
		// void
  }
  
  function __requestUpdate() {
    if (__dirty) return;
    __dirty = true;
    if (__parent == null) {
      Delay.add(() -> {
        __render(__context);
        // __context.dispatchEffects();
      });
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
      Delay.add(() -> {
        __dequeuePendingChildren();
        // __context.dispatchEffects();
      });
    }
  }

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
