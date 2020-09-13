package blok.core;

using Reflect;

class StateProvider<T:State, Node> extends Component<Node> {
  /**
    Provides multiple states at once.
  **/
  public static function provide<Node>(states:Array<State>, build:(context:Context<Node>)->VNode<Node>):VNode<Node> {
    var node:VNode<Node> = null;
    for (state in states) {
      var prev = node;
      node = VComponent(StateProvider, {
        props: {},
        create: (_) -> state,
        build: prev != null ? (ctx) -> prev : build
      });
    }
    return node;
  }

  public static function __create<Props, T:State, Node>(props:{
    props:Props,
    create:(props:Props)->T,
    build:(context:Context<Node>)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>):Component<Node> {
    var provider = new StateProvider(props.create(props.props), props.build, context, parent);
    provider.__inserted = true;
    return provider;
  }

  var state:T;
  var build:(context:Context<Node>)->VNode<Node>;

  public function new(state, build, context, parent) {
    this.state = state;
    this.build = build;
    this.__parent = parent;
    __registerContext(context);
    __render(__context);
  }

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    __context.set(state.__getId(), state);
  }

  override function __shouldUpdate(props:Dynamic):Bool {
    if (props.hasField('state')) {
      var newState:T = props.field('state');
      return state != newState;
    }
    return false;
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('state')) {
      var newState = props.field('state');
      if (newState != state) {
        state = newState;
      }
    }
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(context);
  }
}
