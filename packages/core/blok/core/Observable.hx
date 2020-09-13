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

typedef ObservableTarget<T> = {
  public function observe():Observable<T>;
}

interface Observable<T> {
  public function getKey():String;
  public function subscribe(listener:ObservableListener<T>):ObservableLink;
  public function notify(value:T):Void;
  public function dispose():Void;
  public function observe():Observable<T>;
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

  public function subscribe(listener:ObservableListener<T>):ObservableLink {
    listener(value);
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

  public inline function observe():Observable<T> {
    return this;
  }
}
