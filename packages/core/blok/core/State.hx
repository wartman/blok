package blok.core;

import haxe.ds.List;

class State {
  var __subscribers:List<() -> Void> = new List();
  var __notifying:Bool;

  public function __subscribe(subscription:() -> Void) {
    __subscribers.add(subscription);
    return () -> __subscribers.remove(subscription);
  }
  
  public function __notify() {
    if (__notifying) return;
    __notifying = true;
    for (subscription in __subscribers) subscription();
    __notifying = false;
  }

  public function __updateProps(props:Dynamic) {
    // noop
  }

  public function __getId():String {
    return ''; // Handled by macro.
  }

  function __dispose() {
    __subscribers = null;
  }
}
