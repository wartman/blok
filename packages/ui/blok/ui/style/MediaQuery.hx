package blok.ui.style;

import blok.core.Style;
import blok.core.VStyle;

// Todo: perhaps something more ambitious?
class MediaQuery {
  public static function raw(condition:String, exprs:Array<VStyleExpr>) {
    return Style.wrap('@media ${condition}', exprs);
  }

  public static function minWidth(width:Unit, exprs) {
    return raw('screen and (min-width: ${width.toString()})', exprs);
  }

  public static function maxWidth(width:Unit, exprs) {
    return raw('screen and (max-width: ${width.toString()})', exprs);
  }
}
