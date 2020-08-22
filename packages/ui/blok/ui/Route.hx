package blok.ui;

class Route<T> extends Component {
  @prop var path:T;
  @prop var children:Children;

  override function render(context:Context):VNode {
    return RouterState.subscribe(context, state -> {
      return if (state.match(path)) VFragment(children) else null;
    });
  }
}
