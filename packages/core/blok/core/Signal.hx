package blok.core;

import haxe.Constraints.Function;

/**
  A generic signal. Can have as many params as you'd like.
  
  (Note: this isn't being used now, but I'm keeping it around in case
  it turns out to be useful. Signals might replace events and change how
  `@effect` works, but we'll have to see if that's actually useful.)

  Implementation from: https://gist.github.com/nadako/b086569b9fffb759a1b5
**/
@:genericBuild(blok.core.SignalBuilder.build())
class Signal<Rest> {}

class SignalBase<T:Function> {
  var head:SignalSubscription<T>;
  var tail:SignalSubscription<T>;
  var toAddHead:SignalSubscription<T>;
  var toAddTail:SignalSubscription<T>;
  var dispatching:Bool;

  public function new() {
    dispatching = false;
  }

  public function add(listener:T, once:Bool = false):SignalSubscription<T> {
    var sub = new SignalSubscription(this, listener, once);

    if (dispatching) {
      if (toAddHead == null) {
        toAddHead = toAddTail = sub;
      } else {
        toAddHead.next = sub;
        sub.previous = toAddTail;
        toAddTail = sub;
      }
    } else {
      if (head == null) {
        head = tail = sub;
      } else {
        tail.next = sub;
        sub.previous = tail;
        tail = sub;
      }
    }

    return sub;
  }

  public inline function addOnce(listener:T) {
    return add(listener, true);
  }

  public function clear() {
    var sub = head;

    while (sub != null) {
      sub.signal = null;
      sub = sub.next;
    }

    head = null;
    tail = null;
    toAddHead = null;
    toAddTail = null;
  }

  public function remove(sub:SignalSubscription<T>) {
    if (head == sub)
      head = head.next;
    if (tail == sub)
      tail = tail.previous;
    if (toAddHead == sub)
      toAddHead = toAddHead.next;
    if (toAddTail == sub)
      toAddTail = toAddTail.previous;
    if (sub.previous != null)
      sub.previous.next = sub.next;
    if (sub.next != null)
      sub.next.previous = sub.previous;
    sub.signal = null;
  }

  inline function startDispatch() {
    dispatching = true;
  }

  inline function endDispatch() {
    dispatching = false;
    if (toAddHead != null) {
      if (head == null) {
        head = toAddHead;
        tail = toAddTail;
      } else {
        tail.next = toAddHead;
        toAddHead.previous = tail;
        tail = toAddTail;
      }
      toAddHead = toAddTail = null;
    }
  }
}

@:allow(blok.core.SignalBase)
class SignalSubscription<T:Function> {
  final listener:T;
  final once:Bool;

  var signal:SignalBase<T>;
  var previous:SignalSubscription<T>;
  var next:SignalSubscription<T>;

  function new(signal, listener, once) {
    this.signal = signal;
    this.listener = listener;
    this.once = once;
  }

  public function cancel():Void {
    if (signal != null) {
      signal.remove(this);
      signal = null;
    }
  }
}
