package blok.ui.history;

import js.Browser;
import haxe.io.Path;
import blok.core.Observable;
import blok.core.ObservableState;

using StringTools;

class BrowserHistory implements History {
  final location:Observable<String>;
  var root:String;

  public function new(?root) {
    this.root = root;
    location = new ObservableState(getLocation(), Type.getClassName(BrowserHistory));
    Browser.window.addEventListener('popstate', (e) -> {
      location.notify(getLocation());
    });
  }

  public function getObservable() {
    return location;
  }
  
  public function getLocation():String {
    var path = Browser.location.pathname + Browser.location.search;
    // todo: what are we actually doing with `root`.
    if (root != null && path.startsWith(root)) {
      return path.substring(root.length);
    }
    return path;
  }

  public function previous():Null<String> {
    Browser.window.history.back();
    return getLocation();
  }

  public function next():Null<String> {
    Browser.window.history.forward();
    return getLocation();
  }

  public function push(url:String):Void {
    Browser.window.history.pushState(null, null, Path.join([ root, url ]));
    location.notify(getLocation());
  }
}
