package blok.core;

using Reflect;

class Provider<Node> extends Component<Node> {
  public static function __create<Node>(props:{
    provisioner:Provisioner<Node>,
    build:(context:Context<Node>)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>) {
    var provider = new Provider(props.provisioner, props.build, context, parent);
    provider.__inserted = true;
    return provider;
  }

  public inline static function provide<Node>(provisioner:Provisioner<Node>, build):VNode<Node> {
    return VComponent(Provider, {
      provisioner: provisioner,
      build: build
    });
  }

  var provisioner:Provisioner<Node>;
  var build:(context:Context<Node>)->VNode<Node>;

  public function new(provisioner, build, context, parent) {
    this.provisioner = provisioner;
    this.build = build;
    this.__parent = parent;
    __registerContext(context);
    __render(__context);
  }

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    provisioner.register(__context);
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('provisioner')) {
      provisioner = props.field('provisioner');
      provisioner.register(__context); // replace previous context? May need a dispose system.
    }
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(context);
  }
}
