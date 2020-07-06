package blok.style;

import blok.core.VStyle;
import blok.core.Style;

@:forward
abstract BackgroundSize(Value) to Value {
  
  public static function auto() {
    return new BackgroundSize('auto');
  }

  public static function cover() {
    return new BackgroundSize('cover');
  }

  public static function contain() {
    return new BackgroundSize('contain');
  }

  public static function custom(width:Unit, height:Unit, ?key:String) {
    var value = Value.compound([ width, height ]);
    return new BackgroundSize(key != null ? Value.keyed(key, value) : value);
  }

  public static function multiple(sizes:Array<BackgroundSize>, key:String) {
    return new BackgroundSize(KeyedValue(key, ListValue(sizes)));
  }

  inline public function new(value:Value) {
    this = value;
  }

}

enum abstract BackgroundAttachment(String) to String {
  var Scroll = 'scroll';
  var Fixed = 'fixed';
  var Local = 'local';
  var Inherit = 'inherit';
  var Initial = 'initial';
  var Unset = 'unset';
}

class Background extends Style {

  @prop var color:Color = null;
  @prop var image:Image = null;
  @prop var size:BackgroundSize = null;
  @prop var attachment:BackgroundAttachment = null;
  @prop var position:EdgeOffsets = null;

  override function render():Array<VStyle> {
    var style:Array<VStyle> = [];

    if (color != null) style.push(VProperty('background-color', color));
    if (image != null) style.push(VProperty('background-image', image));
    if (size != null) style.push(VProperty('background-size', size));
    if (position != null) style.push(VProperty('background-position', position));
    if (attachment != null) style.push(VProperty('background-attachment', attachment));

    return style;
  }

}
