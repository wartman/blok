package blok.ui.style;

import blok.core.Style;
import blok.core.VStyle;

@:forward
abstract GridDefinition(Value) to Value {
  // todo: `times` can be `auto-fit`, maybe other keywords too?
  public static function repeat(times:Int, size:Value) {
    return new GridDefinition(Value.call('repeat', Value.list([ times, size ])));
  }

  public static function define(segments:Array<Value>) {
    return new GridDefinition(Value.compound(segments));
  }
  
  public inline function new(value) {
    this = value;
  }
}

/**
  Generates rules for the CSS Grid layout. This class should
  be used for the grid wrapper, not for grid items (use GridItem
  for that).
**/
class Grid extends Style {
  @prop var columns:GridDefinition = null;
  @prop var rows:GridDefinition = null;
  @prop var gap:Unit = null;

  override function render():Array<VStyleExpr> {
    var styles:Array<VStyleExpr> = [
      Style.property('display', 'grid')
    ];

    if (gap != null)
      styles.push(Style.property('grid-gap', gap));
    if (columns != null) 
      styles.push(Style.property('grid-template-columns', columns));
    if (rows != null)
      styles.push(Style.property('grid-template-rows', rows));

    return styles;
  }
}
