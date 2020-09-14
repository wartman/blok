package blok.core;

typedef ObservableListener<T> = (value:T)->Void;

abstract ObservableLink(()->Void) {
  public inline function new(link) {
    this = link;
  }

  public inline function cancel() {
    this();
  }
}

typedef ObservableType<T> = {
  public function observe():Observable<T>;
};

/**
  Allows either `Observable<T>` or `ObservableType<T>` to be
  used interchangeably.
**/
abstract ObservableTarget<T>(Observable<T>) from Observable<T> to Observable<T> {
  @:from public static inline function ofObservableType<T>(obs:ObservableType<T>) {
    return new ObservableTarget(obs.observe());
  }

  public inline function new(obs) {
    this = obs;
  }
}

typedef ObservableOptions = {
  /**
    If `true`, the ObservableListener will NOT be run immediately,
    and will only be called when the observer is next notified.
  **/
  public var defer:Bool;
}

interface Observable<T> {
  public function getKey():String;
  public function subscribe(listener:ObservableListener<T>, ?options:ObservableOptions):ObservableLink;
  public function notify(value:T):Void;
  public function dispose():Void;
}

class ObservableValue<T> implements Observable<T> {
  public static inline function of<T>(value:T, ?key) {
    return new ObservableValue(value, key);
  }

  final key:String;
  
  var listeners:List<ObservableListener<T>> = new List();
  var notifying:Bool = false;
  var value:T;

  public function new(value:T, ?key) {
    this.value = value;
    this.key = if (key == null) {
      Type.getClassName(Type.getClass(this));
    } else key;
  }

  public function getKey():String {
    return key;
  }

  public function subscribe(listener:ObservableListener<T>, ?options:ObservableOptions):ObservableLink {
    if (options == null) options = { defer: false }; 
    if (!options.defer) listener(value);
    listeners.add(listener);
    return new ObservableLink(() -> listeners.remove(listener));
  }

  public function notify(value:T) {
    if (notifying) return;
    notifying = true;
    this.value = value;
    for (listener in listeners) listener(value);
    notifying = false;
  }

  public function dispose() {
    listeners.clear();
  }
}
