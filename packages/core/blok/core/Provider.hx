package blok.core;

using Reflect;

class Provider<Node> extends Component<Node> {
  public static function __create<Node>(props:{
    register:(context:Context<Node>)->Void,
    build:(context:Context<Node>)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>) {
    var provider = new Provider(props.register, props.build, context, parent);
    provider.__inserted = true;
    return provider;
  }

  public inline static function provide<Node>(data:Array<Provisioner<Node>>, build):VNode<Node> {
    return provideValue(context -> {
      for (provisioner in data) provisioner.__register(context);
    }, build);
  }

  public inline static function provideValue<T, Node>(
    register:(context:Context<Node>)->Void,
    build:(context:Context<Node>)->VNode<Node> 
  ):VNode<Node> {
    return VComponent(Provider, {
      register: register,
      build: build
    });
  }

  public static function provideMap<Node>(
    data:Map<String, Dynamic>,
    build:(context:Context<Node>)->VNode<Node> 
  ):VNode<Node> {
    return provideValue(context -> {
      for (key => value in data) context.set(key, value);
    }, build);
  }

  var register:(context:Context<Node>)->Void;
  var build:(context:Context<Node>)->VNode<Node>;

  public function new(register, build, context, parent) {
    this.register = register;
    this.build = build;
    this.__parent = parent;
    __registerContext(context);
    __render(__context);
  }

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    register(__context);
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('register')) {
      register = props.field('register');
      register(__context); // replace previous context? May need a dispose system.
    }
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(context);
  }
}
