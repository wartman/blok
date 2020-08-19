package blok.scaffold;

using Lambda;

typedef PortalEntry = { key:String, vnode:VNode }; 

class PortalState extends State {
  @prop var portals:Array<PortalEntry> = [];

  @update
  public function addPortal(key:String, vnode:VNode) {
    if (portals.exists(entry -> entry.key == key)) return null;
    return { portals: portals.concat([ { key: key, vnode: vnode } ]) };
  }

  @update
  public function removePortal(key:String) {
    if (!portals.exists(entry -> entry.key == key)) return null;
    return { portals: portals.filter(entry -> entry.key != key) }
  }
}
