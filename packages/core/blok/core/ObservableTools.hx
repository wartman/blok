package blok.core;

import blok.core.Observable;

@:access(blok.core.Observable)
class ObservableTools {
  public static inline function map<T, R>(
    observable:ObservableTarget<T>,
    transform:(value:T)->R,
    ?key
  ):Observable<R> {
    return new LinkedObservable(observable, transform, key);
  }

  public static inline function mapToNode<T, Node>(observable:ObservableTarget<T>, build) {
    return ObservableSubscriber.observe(observable, build);
  }
}

private final class LinkedObservable<T, R> extends Observable<R> {
  var link:Observer<T>;

  public function new(parent:Observable<T>, transform:(value:T)->R, ?key) {
    super(transform(parent.value), key);
    link = parent.observe(value -> notify(transform(value)), { defer: true });
  }

  override function dispose() {
    link.cancel();
    link = null;
    super.dispose();
  }
}
