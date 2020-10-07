package blok.core;

import blok.core.Plugin;

class PluginProvider<T:Plugin<Node>, Node> extends Component<Node> {
  public static function __create<T:Plugin<Node>, Node>(props:{
    pluginFactory:()->T,
    build:(context:Context<Node>)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>) {
    var provider = new PluginProvider(props.pluginFactory, props.build, context, parent);
    provider.__inserted = true;
    return provider;
  }

  public static function provide<T:Plugin<Node>, Node>(
    pluginFactory:()->T,
    build:(context:Context<Node>)->VNode<Node> 
  ):VNode<Node> {
    return VComponent(PluginProvider, {
      pluginFactory: pluginFactory,
      build: build
    });
  }

  var pluginFactory:()->T;
  var build:(context:Context<Node>)->VNode<Node>;

  public function new(pluginFactory, build, context, parent) {
    this.pluginFactory = pluginFactory;
    this.build = build;
    __registerContext(context);
    __render(__context);
  }

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    __context.addPlugin(pluginFactory());
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(context);
  }
}
