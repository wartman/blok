package blok.ui.history;

import js.Browser;

using StringTools;

class BrowserHistory implements History {
  var root:String;

  public function new(?root) {
    this.root = root;
    // Browser.window.addEventListener('popstate', (e) -> {
    //   // onChangeTrigger.trigger(getLocation());
    // });
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
    Browser.window.history.pushState(null, null, url);
  }
}
