package blok.ui.style;

import blok.core.style.StyleExpr;
import blok.core.html.CssUnit;
import blok.core.html.Css;

// Todo: perhaps something more ambitious?
class MediaQuery {
  public static function raw(condition:String, exprs:Array<StyleExpr>) {
    return Css.wrap('@media ${condition}', exprs);
  }

  public static function minWidth(width:CssUnit, exprs) {
    return raw('screen and (min-width: ${width.toString()})', exprs);
  }

  public static function maxWidth(width:CssUnit, exprs) {
    return raw('screen and (max-width: ${width.toString()})', exprs);
  }
}
