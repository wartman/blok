package blok.h2d;

import h2d.Tile;

class Flow extends h2d.Flow implements NativeObject {
  public final classList:ClassList = new ClassList();

  public var backgroundColor(never, set):Int;
  function set_backgroundColor(value:Int) {
    if (value != null) {
      var tile = Tile.fromColor(value, 0, 0);
      backgroundTile = tile;
    }
    return value;
  }

  public var height(never, set):Int;
  function set_height(value:Int) {
    minHeight = maxHeight = value;
    return value;
	}

  public var width(never, set):Int;
  function set_width(value:Int) {
    minWidth = maxWidth = value;
    return value;
	}
}
