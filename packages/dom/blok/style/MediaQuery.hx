package blok.style;

import blok.internal.Style;
import blok.internal.VStyle;

class MediaQuery {
  // to-do: actual queries
  public static function where(minWidth:Unit, style:VStyleExpr) {
    return Style.wrap('@media screen and (min-width: ${minWidth.toString()})', style);
  }
}
