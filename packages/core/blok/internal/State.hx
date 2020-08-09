package blok.internal;

class State<Node> extends Component<Node> {
  var __subscribers:Array<() -> Void> = [];
  var __factory:(context:Context<Node>) -> VNode<Node>;

  function __register(context:Context<Node>) {
    if (__context == context) return __context;
    __context = context.getChild();
    __context.set(__getId(), this);
    return __context;
  }
  
  function __dispatch() {
    for (sub in __subscribers) sub();
  }

  public function __subscribe(listener:() -> Void) {
    __subscribers.push(listener);
    return () -> __subscribers.remove(listener);
  }

  function __getId():String {
    return ''; // Handled by macro.
  }

  override function render(context:Context<Node>):VNode<Node> {
    return __factory(context);
  }

  override function __update(props:Dynamic, context:Context<Node>, parent:Component<Node>) {
    super.__update(props, __register(context), parent);
  }

  override function __dispose() {
    __subscribers = null;
    super.__dispose();
  }
}
