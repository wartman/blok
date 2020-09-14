package blok.core;

import blok.core.Observable;

class ObservableTools {
  public static function map<T, R>(
    observable:Observable<T>,
    transform:(value:T)->R,
    ?key
  ) {
    var obs:Observable<R> = new ObservableValue(null, key);
    observable.subscribe(value -> obs.notify(transform(value)));
    return obs;
  }

  public static function mapToSubscriber<T, Node>(observable:Observable<T>, build) {
    return ObservableSubscriber.subscribe(observable, build);
  }
}
