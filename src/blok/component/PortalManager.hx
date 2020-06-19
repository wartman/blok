package blok.component;

import blok.html.Html;
import blok.core.VNode;
import blok.core.Context;
import blok.core.Component;

class PortalManager extends Component {

  @prop var children:Array<VNode>;

  override function render(context:Context):VNode {
    return PortalState.provide(context, {}, childContext -> Html.fragment([
      PortalState.subscribe(childContext, state -> 
        Html.fragment(state.portals.map(portal -> portal.vnode))
      ),
      Html.fragment(children, Type.getClassName(PortalManager))
    ]));
  }

}
