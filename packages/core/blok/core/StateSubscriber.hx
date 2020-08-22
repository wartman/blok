package blok.core;

using Reflect;

final class StateSubscriber<T:State<Node>, Node> extends Component<Node> {
  public static function __create<T:State<Node>, Node>(props:{
    state:T,
    build:(state:T)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>):Component<Node> {
    var sub = new StateSubscriber(props.state, props.build, context, parent);
    sub.__inserted = true;
    return sub;
  }

  var build:(state:T)->VNode<Node>;
  var state:T;
  var unsub:()->Void;

  public function new(state, build, context, parent) {
    this.state = state;
    this.build = build;
    this.__context = context;
    this.__parent = parent;
    this.unsub = state.__subscribe(__requestUpdate);
    __render(__context);
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('state')) {
      var newState:T = props.field('state');
      if (newState != state) {
        if (unsub != null) unsub();
        unsub = newState.__subscribe(__requestUpdate);
        state = newState;
      }
    }
    if (props.hasField('build')) {
      var newBuild = props.field('build');
      if (newBuild != build) {
        build = newBuild;
      }
    }
  }

  override function __dispose() {
    if (unsub != null) unsub();
    super.__dispose();
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(state);
  }
}
