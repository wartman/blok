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

  public static function observe<T, Node>(observable:ObservableTarget<T>, build:(value:T)->VNode<Node>):VNode<Node> {
    return VComponent(ObservableSubscriber, {
      observable: observable,
      build: build
    });
  }

  var value:T;
  var build:(value:T)->VNode<Node>;
  var observable:Observable<T>;
  var link:ObservableLink;

  public function new(observable, build, context, parent) {
    this.observable = observable;
    this.build = build;
    this.__parent = parent;

    var first = true;
    this.link = observable.subscribe(value -> {
      this.value = value;
      if (!first) {
        __requestUpdate();
      } else {
        first = false;
      }
    });

    __registerContext(context);
    __render(__context);
  }

  override function __updateProps(props:Dynamic) {
    if (props.hasField('observable')) {
      var newObservable:Observable<T> = props.field('observable');
      if (newObservable != observable) {
        if (link != null) link.cancel();
        link = newObservable.subscribe(value -> {
          this.value = value;
          __requestUpdate();
        });
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
    return build(value);
  }
}
