package blok.style;

import blok.core.VStyle;

class Css {

  public inline static function select(selector:String, rules:Array<VStyle>) {
    return VChild(selector, rules);
  }

  public inline static function margin(top:Unit, right:Unit, bottom:Unit, left:Unit) {
    return VProperty('margin', Value.compound([ top, right, bottom, left ]));
  }

  public inline static function padding(top:Unit, right:Unit, bottom:Unit, left:Unit) {
    return VProperty('padding', Value.compound([ top, right, bottom, left ]));
  }

  public inline static function color(color:Color) {
    return VProperty('color', color);
  }

  public inline static function backgroundColor(color:Color) {
    return VProperty('background-color', color);
  }

  public inline static function backgroundImage(image:Image) {
    return VProperty('background-image', image);
  }

  // ... and a *lot* more

}
