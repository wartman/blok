package blok.ui.style;

import blok.core.html.CssUnit;
import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;
import blok.core.html.CssValue;

@:forward
abstract GridDefinition(CssValue) to CssValue {
  // todo: `times` can be `auto-fit`, maybe other keywords too?
  public static function repeat(times:Int, size:CssValue) {
    return new GridDefinition(CssValue.call('repeat', CssValue.list([ times, size ])));
  }

  public static function define(segments:Array<CssValue>) {
    return new GridDefinition(CssValue.compound(segments));
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
  @prop var gap:CssUnit = null;

  override function render():StyleExpr {
    var styles:Array<StyleExpr> = [
      Css.property('display', 'grid')
    ];

    if (gap != null)
      styles.push(Css.property('grid-gap', gap));
    if (columns != null) 
      styles.push(Css.property('grid-template-columns', columns));
    if (rows != null)
      styles.push(Css.property('grid-template-rows', rows));

    return Css.properties(styles);
  }
}
