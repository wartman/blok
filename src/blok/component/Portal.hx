package blok.component;

import blok.core.Context;
import blok.core.VNode;
import blok.core.Component;

class Portal extends Component {
  
  static var id:Int = 0;

  @prop var child:VNode;
  final key:String = 'portal_${id++}';

  @init
  function registerPortal() {
    PortalState
      .forContext(getCurrentContext())
      .addPortal(key, child);
  }

  @dispose
  function removePortal() {
    PortalState
      .forContext(getCurrentContext())
      .removePortal(key);
  }

  override function render(context:Context):VNode {
    return null;
  }

}
