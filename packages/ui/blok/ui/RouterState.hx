package blok.ui;

import blok.core.Observable;

class RouterState<Route:EnumValue> implements State {
  @prop var urlToRoute:(url:String)->Route;
  @prop var routeToUrl:(route:Route)->String;
  @prop var history:History;
  @prop var route:Route = null;
  @prop var url:String = null;

  var link:Observer<String>;

  @init
  function setup() {
    // @todo: add a first-class way to watch Observables?
    link = history.getObservable().observe(setUrl);
  }

  @dispose
  function cleanup() {
    link.cancel();
  }
  
  public function setRoute(route:Route) {
    if (!this.route.equals(route)) {
      history.push(routeToUrl(route));
    }
  }

  public function previous() {
    history.previous();
  }

  public function next() {
    history.next();
  }

  @update
  function setUrl(url:String) {
    var route = urlToRoute(url);
    if (this.route.equals(route)) return None;
    return UpdateState({
      url: url,
      route: route
    });
  }
}
