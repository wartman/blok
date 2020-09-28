package blok.ui;

using Lambda;

typedef PortalEntry = { key:String, vnode:VNode }; 

class PortalState implements State {
  @prop var portals:Array<PortalEntry> = [];

  @update
  public function addPortal(key:String, vnode:VNode) {
    if (portals.exists(entry -> entry.key == key)) return None;
    return UpdateState({ 
      portals: portals.concat([ { key: key, vnode: vnode } ]) 
    });
  }

  @update
  public function removePortal(key:String) {
    if (!portals.exists(entry -> entry.key == key)) return None;
    return UpdateState({ 
      portals: portals.filter(entry -> entry.key != key) 
    });
  }
}
