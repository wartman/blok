package blok.style;

import blok.core.VStyle;
import blok.core.Style;

abstract BackgroundSize(Value) to Value {
  
  public static function auto() {
    return new BackgroundSize(SingleValue('auto'));
  }

  public static function cover() {
    return new BackgroundSize(SingleValue('cover'));
  }

  public static function contain() {
    return new BackgroundSize(SingleValue('contain'));
  }

  public static function custom(width:Unit, height:Unit, ?key:String) {
    var value = CompoundValue([ SingleValue(width), SingleValue(height) ]);
    return new BackgroundSize(key != null ? KeyedValue(key, value) : value);
  }

  public static function multiple(sizes:Array<BackgroundSize>, key:String) {
    return new BackgroundSize(KeyedValue(key, ListValue(sizes)));
  }

  inline public function new(value:Value) {
    this = value;
  }

}

class Background extends Style {

  @prop var color:Color = null;
  @prop var image:Image = null;
  @prop var size:BackgroundSize = null;
  @prop var position:EdgeOffsets = null;

  override function render():Array<VStyle> {
    var style:Array<VStyle> = [];

    if (color != null) style.push(VProperty('background-color', color));
    if (image != null) style.push(VProperty('background-image', image));
    if (size != null) style.push(VProperty('background-size', size));
    if (position != null) style.push(VProperty('background-position', position));

    return style;
  }

}
