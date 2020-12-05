package blok.core;

using Reflect;

class Provider<Node> extends Component<Node> {
  public static function __create<Node>(props:{
    value:Providable<Node>,
    build:(context:Context<Node>)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>) {
    var provider = new Provider(props.value, props.build, context, parent);
    provider.__inserted = true;
    return provider;
  }

  public inline static function provide<Node>(value:Providable<Node>, build):VNode<Node> {
    return VComponent(Provider, {
      value: value,
      build: build
    });
  }

  var value:Providable<Node>;
  var build:(context:Context<Node>)->VNode<Node>;

  public function new(value, build, context, parent) {
    this.value = value;
    this.build = build;
    this.__parent = parent;
    __registerContext(context);
    __render(__context);
  }

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    value.register(__context);
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('value')) {
      value = props.field('value');
      value.register(__context); // replace previous context? May need a dispose system.
    }
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(context);
  }
}
