package blok.internal;

@:build(blok.internal.ComponentBuilder.build('Node'))
final class StateSubscriber<T:State<Node>, Node> extends Component<Node> {
  
  @prop var state:T;
  @prop var build:(state:T)->VNode<Node>;
  var unsub:()->Void;

  @init
  function subscribe() {
    unsub = state.__subscribe(__requestUpdate);
  }

  @dispose
  function unsubscribe() {
    if (unsub != null) unsub();
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(state);
  }
  
}
