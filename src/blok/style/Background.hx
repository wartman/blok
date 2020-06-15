package blok.style;

import blok.core.VStyle;
import blok.core.Style;

class Background extends Style {

  @prop var color:Color;
  // @todo: images and attachment and stuff

  override function render():Array<VStyle> {
    return [
      VProperty('background-color', color)
    ];
  }

}
