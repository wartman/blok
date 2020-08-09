package blok.core;

final class StateSubscriber<T:State> extends Component {
  
  @prop var state:T;
  @prop var build:(state:T)->VNode;
  var unsub:()->Void;

  @init
  function subscribe() {
    unsub = state.__subscribe(__requestUpdate);
  }

  @dispose
  function unsubscribe() {
    if (unsub != null) unsub();
  }

  override function render(context:Context):VNode {
    return build(state);
  }

}