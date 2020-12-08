package blok.core.foundation.routing;

using Blok;

class Router<Route:EnumValue> extends Component {
  @prop var urlToRoute:(url:String)->Route;
  @prop var routeToUrl:(route:Route)->String;
  @prop var match:(route:Route)->VNode;
  @prop var history:History;

  override function render(context:Context) {
    return RouterState.provide({
      urlToRoute: urlToRoute,
      routeToUrl: routeToUrl,
      history: history,
      url: history.getLocation(),
      route: urlToRoute(history.getLocation())
    }, ctx -> RouterState.observe(ctx, state -> match(state.route)));
  }
}
