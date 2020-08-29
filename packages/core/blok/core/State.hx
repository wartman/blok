package blok.core;

import haxe.ds.List;

class State<Node> extends Component<Node> {
  var __subscribers:List<() -> Void> = new List();
  var __factory:(context:Context<Node>) -> VNode<Node>;

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    __context.set(__getId(), this);
  }
  
  function __dispatch() {
    for (subscription in __subscribers) subscription();
  }

  public function __subscribe(subscription:() -> Void) {
    __subscribers.add(subscription);
    return () -> __subscribers.remove(subscription);
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
