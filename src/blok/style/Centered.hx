package blok.style;

import blok.core.VStyle;
import blok.core.Style;

// Hmm.
class Centered extends Style {
  
  override function render():Array<VStyle> {
    return [
      Layout.export({
        direction: Row
      }),
      VRaw('
        flex-wrap: wrap;
        justify-content: center;
        align-items: center;
      ')
    ];
  }

}
