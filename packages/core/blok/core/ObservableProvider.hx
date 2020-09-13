package blok.core;

import blok.core.Observable;

using Reflect;

class ObservableProvider<T, Node> extends Component<Node> {
  public static function provide<Node>(observables:Array<ObservableTarget<Dynamic>>, build:(context:Context<Node>)->VNode<Node>):VNode<Node> {
    var node:VNode<Node> = null;
    for (observable in observables) {
      var prev = node;
      node = VComponent(ObservableProvider, {
        observable: observable,
        build: prev != null ? (ctx) -> prev : build
      });
    }
    return node;
  }

  public static function __create<T, Node>(props:{
    observable:ObservableTarget<T>,
    build:(context:Context<Node>)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>):Component<Node> {
    var provider = new ObservableProvider(props.observable.observe(), props.build, context, parent);
    provider.__inserted = true;
    return provider;
  }

  var observable:Observable<T>;
  var build:(context:Context<Node>)->VNode<Node>;

  public function new(observable, build, context, parent) {
    this.observable = observable;
    this.build = build;
    this.__parent = parent;
    __registerContext(context);
    __render(__context);
  }

  override function __registerContext(context:Context<Node>) {
    if (context == __context) return;
    __context = context.getChild();
    __context.set(observable.getKey(), observable);
  }

  override function __shouldUpdate(props:Dynamic):Bool {
    if (props.hasField('observable')) {
      var newObservable:Observable<T> = props.field('observable');
      return observable != newObservable;
    }
    return false;
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('observable')) {
      var newObservable = props.field('observable');
      if (newObservable != observable) {
        observable = newObservable;
      }
    }
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(context);
  }
}