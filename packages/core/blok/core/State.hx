package blok.core;

class State<Node> extends Component<Node> {
  var __subscribers:Array<() -> Void> = [];
  var __factory:(context:Context<Node>) -> VNode<Node>;

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    __context.set(__getId(), this);
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

  override function __dispose() {
    __subscribers = null;
    super.__dispose();
  }
}
