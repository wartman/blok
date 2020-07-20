package blok.component;

import blok.core.VNode;
import blok.core.Context;
import blok.core.Component;

class PortalManager extends Component {

  @prop var children:Array<VNode>;

  override function render(context:Context):VNode {
    return PortalState.provide(context, {}, childContext -> VFragment([
      PortalState.subscribe(childContext, state -> 
        VFragment(state.portals.map(portal -> portal.vnode))
      ),
      VFragment(children, Type.getClassName(PortalManager))
    ]));
  }

}
