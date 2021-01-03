package blok.core.foundation.portal;

using Blok;

class PortalManager extends Component {
  @prop var children:Array<VNode>;

  override function render(context:Context):VNode {
    return PortalState.provide({}, childContext -> VFragment([
      PortalState.target(childContext),
      VFragment(children, Type.getClassName(PortalManager))
    ]));
  }
}
