package blok.core.foundation.routing.history;

import js.Browser;
import blok.core.Observable;

using StringTools;

class HashHistory implements History {
  final location:Observable<String>;

  public function new() {
    location = new Observable(getLocation());
    Browser.window.addEventListener('popstate', (e) -> location.notify(getLocation()));
  }

  public function getObservable() {
    return location;
  }

  public function getLocation():String {
    var hash = Browser.location.hash;
    if (hash.startsWith('#')) return hash.substr(1);
    return hash;
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
    var path = Browser.location.href;
    if (path.contains('#')) {
      path = path.substring(0, path.indexOf('#'));
    }
    if (url.length > 0) {
      url = '#' + url;
    }
    path += url;
    Browser.window.history.pushState(null, null, path);
    location.notify(getLocation());
  }
}
