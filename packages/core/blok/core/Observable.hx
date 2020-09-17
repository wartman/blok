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
abstract ObservableTarget<T>(Observable<T>) from Observable<T> to Observable<T> {
  @:from public static inline function ofObservableType<T>(obs:ObservableType<T>) {
    return new ObservableTarget(obs.getObservable());
  }

  public inline function new(obs) {
    this = obs;
  }
}

typedef ObservableComparitor<T> = (a:T, b:T)->Bool; 

@:nullSafety()
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

// @todo: we need to check that this singly-linked list actually
//        works right if we add a listener while dispatching.
@:nullSafety()
class Observable<T> {
  static var uid:Int = 0;

  final key:String;
  final comparitor:Null<ObservableComparitor<T>>;

  var notifying:Bool = false;
  var value:T;
  var head:Null<Observer<T>>;
  var toAddHead:Null<Observer<T>>;

  public function new(value, ?key, ?comparitor) {
    this.value = value;
    this.key = if (key == null) 'observe_${uid++}' else key;
    this.comparitor = comparitor;
  }
  
  public function getKey():String {
    return key;
  }

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

  public function notify(value:T):Void {
    if (comparitor != null && comparitor(this.value, value)) return;
    
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
}
