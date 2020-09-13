package blok.core;

import blok.core.Observable;

using Reflect;

final class ObservableSubscriber<T, Node> extends Component<Node> {
  public static function __create<T, Node>(props:{
    observable:ObservableTarget<T>,
    build:(value:T)->VNode<Node>
  }, context:Context<Node>, parent:Component<Node>):Component<Node> {
    var sub = new ObservableSubscriber(props.observable.observe(), props.build, context, parent);
    sub.__inserted = true;
    return sub;
  }

  public static function observe<T, Node>(observable:Observable<T>, build:(value:T)->VNode<Node>):VNode<Node> {
    return VComponent(ObservableSubscriber, {
      observable: observable,
      build: build
    });
  }

  var build:(value:T)->VNode<Node>;
  var observable:Observable<T>;
  var link:ObservableLink;

  public function new(observable, build, context, parent) {
    this.observable = observable;
    this.build = build;
    this.__parent = parent;
    this.link = observable.subscribe(_ -> __requestUpdate());
    __registerContext(context);
    __render(__context);
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('observable')) {
      var newObservable:Observable<T> = props.field('observable');
      if (newObservable != observable) {
        if (link != null) link.cancel();
        link = newObservable.subscribe(_ -> __requestUpdate());
        observable = newObservable;
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
    if (link != null) link.cancel();
    super.__dispose();
  }

  override function render(context:Context<Node>):VNode<Node> {
    return build(observable.value);
  }
}
