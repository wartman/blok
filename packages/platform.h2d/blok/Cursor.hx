package blok;

import h2d.Object;

class Cursor implements blok.core.Cursor<Object> {
  final parent:Object;
  var pos:Int;

  public function new(parent, pos) {
    this.parent = parent;
    this.pos = pos;
  }

  public function insert(node:Object):Bool {
    var inserted = node.parent != parent;
    parent.addChildAt(node, pos);
    pos++;
    return inserted;
  }

  public function step():Bool {
    return if (pos >= parent.numChildren) {
      false;
    } else {
      pos++ == parent.numChildren;
    }
  }

  public function delete():Bool {
    if (pos <= parent.numChildren) {
      parent.removeChild(current());
      return true;
    }
    return false;
  }

  public function current():Object {
    return parent.getChildAt(pos);
  }
}
