package blok.core;

typedef ObservableType<T> = {
  public function getObservable():Observable<T>;
};

typedef ObservableOptions = {
  /**
    If `true`, the Observer will NOT be run immediately,
    and will only be called when the observer is next notified.
  **/
  public var defer:Bool;
}

/**
  Allows either `Observable<T>` or `ObservableType<T>` to be
  used interchangeably.
**/
@:forward(observe)
abstract ObservableTarget<T>(Observable<T>) from Observable<T> to Observable<T> {
  @:from public static inline function ofObservableType<T>(obs:ObservableType<T>) {
    return new ObservableTarget(obs.getObservable());
  }

  public inline function new(obs) {
    this = obs;
  }
}

typedef ObservableComparitor<T> = (a:T, b:T)->Bool; 

@:nullSafety
@:allow(blok.core.Observable)
class Observer<T> {
  final listener:(value:T)->Void;
  
  var observable:Null<Observable<T>>;
  var next:Null<Observer<T>>;

  public function new(observable, listener) {
    this.observable = observable;
    this.listener = listener;
  }

  public inline function handle(value:T) {
    listener(value);
  }

  public function cancel() {
    if (observable != null) {
      observable.remove(this);
      observable = null;
    }
  }
}

@:nullSafety
class Observable<T> {
  static var uid:Int = 0;

  public static inline function ofMany<T>(observables, ?key) {
    return new DependencyObservable(observables, key);
  }

  @:allow(blok.core.ObservableProvider) final key:String;
  final comparator:Null<ObservableComparitor<T>>;

  var notifying:Bool = false;
  var value:T;
  var head:Null<Observer<T>>;
  var toAddHead:Null<Observer<T>>;

  public function new(value, ?key, ?comparator) {
    this.value = value;
    this.key = if (key == null) 'observe_${uid++}' else key;
    this.comparator = comparator;
  }

  // @todo: we need to check that this singly-linked list actually
  //        works right if we add a listener while dispatching.
  public function observe(listener:(value:T)->Void, ?options:ObservableOptions):Observer<T> {
    if (options == null) options = { defer: false };
    
    var observer = new Observer(this, listener);
    
    if (notifying) {
      observer.next = toAddHead;
      toAddHead = observer;
    } else {
      observer.next = head;
      head = observer;
    }
    
    if (!options.defer) observer.handle(value);

    return observer;
  }

  public function notify(value:T):Void {
    if (comparator != null && comparator(this.value, value)) return;
    
    notifying = true;

    this.value = value;
    
    var current = head;
    while (current != null) {
      current.handle(this.value);
      current = current.next;
    }

    notifying = false;
    
    if (toAddHead != null) {
      if (current != null) {
        current.next = toAddHead;
      } else {
        head = toAddHead;
      }
      toAddHead = null;
    }
  }
  
  public function remove(observer:Observer<T>):Void {
    inline function clearObserver() {
      observer.next = null;
      observer.observable = null;
    }

    inline function iterate(head:Null<Observer<T>>) {
      var current = head;
      while (current != null) {
        if (current.next == observer) {
          current.next = observer.next;
          clearObserver();
          break;
        }
        current = current.next;
      }
    }

    if (head == observer) {
      head = observer.next;
      clearObserver();
      return;
    }

    iterate(head);
    iterate(toAddHead);
  }

  public function dispose():Void {
    inline function iterate(head:Null<Observer<T>>) {
      var current = head;
      while (current != null) {
        var next = current.next;
        current.observable = null;
        current.next = null;
        current = next;
      }
    }

    iterate(head);
    iterate(toAddHead);

    head = null;
    toAddHead = null;
  }

  public inline function map<R>(transform:(value:T)->R, ?key):Observable<R> {
    return new LinkedObservable(this, transform, key);
  }

  public inline function join(b:Observable<T>):Observable<Array<T>> {
    return new DependencyObservable([ this, b ]);
  }

  public inline function mapToNode<Node>(build) {
    return ObservableSubscriber.observe(this, build);
  }
}

final class LinkedObservable<T, R> extends Observable<R> {
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

// @todo: Unsure if this is a good idea.
//        We should make Observable as simple and flexable as possible --
//        if someone wants to use reactive programming, they should
//        *not* use this.
final class DependencyObservable<T> extends Observable<Array<T>> {
  var links:Array<Observer<T>>;
  
  public function new(observables:Array<Observable<T>>, ?key) {
    var value:Array<T> = [];
    for (i in 0...observables.length) {
      value[i] = observables[i].value;
      links[i] = observables[i].observe(value -> {
        this.value[i] = value;
        notify(this.value);
      }, { defer: true });
    }
    super(value, key);
  }

  public function addDependency(observable:Observable<T>) {
    var i = value.length;
    value[i] = observable.value;
    links[i] = observable.observe(value -> {
      this.value[i] = value;
      notify(this.value);
    }, { defer: true });
  }

  public function removeDependency(observable:Observable<T>) {
    var i = this.value.indexOf(observable.value);
    if (i > -1) {
      var link = links[i];
      link.cancel();
      value.remove(value[i]);
      links.remove(link);
    }
  }

  override function dispose() {
    value = null;
    for (l in links) l.cancel();
    super.dispose();
  }
}
