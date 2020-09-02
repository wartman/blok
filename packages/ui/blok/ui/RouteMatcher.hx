package blok.ui;

class RouteMatcher<Route:EnumValue> extends Component {
  @prop var route:Route;
  @prop var children:Children;

  override function render(context:Context):VNode {
    return RouterState.subscribe(context, (state:RouterState<Route>) -> {
      return if (state.route.equals(route)) VFragment(children) else null;
    });
  }
}
