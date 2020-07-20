package blok.platform.dom;

import blok.core.VStyle;
import blok.style.EdgeInsets;
import blok.style.Color;
import blok.style.Image;
import blok.style.Background.BackgroundAttachment;

/**
  Note that the properties here are not comprehensive! These are just
  some of the most common ones someone might use.

  If there isn't a prop listed here, use `Css.property(name, value)`.
**/
class Css {

  public inline static function select(selector:String, styles:Array<VStyle>) {
    return VChild(selector, styles);
  }

  // todo: potentially add an abstract for the mediaQuery selector.
  public inline static function mediaQuery(selector:String, styles:Array<VStyle>) {
    return VMedia(selector, styles);
  }

  public inline static function property(name:String, value:Value, important = false) {
    return VProperty(name, value, important);
  }

  public inline static function margin(edges:EdgeInsets, important = false) {
    return property('margin', edges, important);
  }

  public inline static function padding(edges:EdgeInsets, important = false) {
    return property('padding', edges, important);
  }

  public inline static function color(color:Color, important = false) {
    return property('color', color, important);
  }

  public inline static function backgroundColor(color:Color, important = false) {
    return property('background-color', color, important);
  }

  public inline static function backgroundImage(image:Image, important = false) {
    return property('background-image', image, important);
  }

  public inline static function backgroundAttachment(attachment:BackgroundAttachment, important = false) {
    return property('background-attachment', attachment, important);
  }

  // ... and a *lot* more

}
