package blok.ui;

class RouterState<Route:EnumValue> extends State {
  @prop var urlToRoute:(url:String)->Route;
  @prop var routeToUrl:(route:Route)->String;
  @prop var history:History;
  // todo: route and url could be @computed?
  @prop var route:Route = null;
  @prop var url:String = null;

  @init
  function setup() {
    if (url == null) setUrl(history.getLocation(), false);
  }

  @update
  public function setUrl(url:String, ?pushState:Bool = true) {
    var route = urlToRoute(url);
    if (this.route.equals(route)) return null; 
    if (pushState) history.push(url);
    return {
      url: url,
      route: route
    };
  }
  
  @update
  public function setRoute(route:Route, ?pushState:Bool = true) {
    if (this.route.equals(route)) return null; 
    var url = routeToUrl(route);
    if (pushState) history.push(url);
    return {
      url: routeToUrl(route),
      route: route
    };
  }

  @update
  public function previous() {
    var previous = history.previous();
    if (previous == null) return null;
    var route = urlToRoute(previous);
    return {
      url: previous,
      route: route
    };
  }

  @update
  public function next() {
    var next = history.next();
    if (next == null) return null;
    var route = urlToRoute(next);
    return {
      url: next,
      route: route
    };
  }
}
