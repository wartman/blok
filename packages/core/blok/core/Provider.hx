package blok.core;

using Reflect;

/**
  Any object that has an `__id` may be used as a Provideable (this
  includes all states).

  @todo: maybe make this an abstract type to allow for easier casting?
**/
typedef Provideable = {
  public final __id:String;
};

class Provider<T, Node> extends Component<Node> {
  public static function __create<T, Node>(props:{
    key:String,
    value:T,
    build:(context:Context<Node>)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>) {
    var provider = new Provider(props.key, props.value, props.build, context, parent);
    provider.__inserted = true;
    return provider;
  }

  public static function provide<Node>(data:Array<Provideable>, build):VNode<Node> {
    var node:VNode<Node> = null;
    for (item in data) {
      var prev = node;
      node = provideValue(item.__id, item, prev != null ? _ -> prev : build);
    }
    return node;
  }

  public inline static function provideValue<T, Node>(
    key:String, 
    value:T,
    build:(context:Context<Node>)->VNode<Node> 
  ):VNode<Node> {
    return VComponent(Provider, {
      key: key,
      value: value,
      build: build
    });
  }

  public static function provideMap<Node>(
    data:Map<String, Dynamic>,
    build:(context:Context<Node>)->VNode<Node> 
  ):VNode<Node> {
    var node:VNode<Node> = null;
    for (key => value in data) {
      var prev = node;
      node = provideValue(key, value, prev != null ? _ -> prev : build);
    }
    return node;
  }

  var key:String;
  var value:T;
  var build:(context:Context<Node>)->VNode<Node>;

  public function new(key:String, value:T, build, context, parent) {
    this.key = key;
    this.value = value;
    this.build = build;
    this.__parent = parent;
    __registerContext(context);
    __render(__context);
  }

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    __context.set(key, value);
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('key')) {
      this.key = props.field('key');
    }
    if (props.hasField('value')) {
      this.value = props.field('value');
    }
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(context);
  }
}
