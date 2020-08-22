package blok.core;

@:forward(contains, iterator)
abstract StyleList(Array<VStyle>) from Array<VStyle> to Array<VStyle> {
  @:from public inline static function ofStyleType(style:VStyle):StyleList {
    return [style];
  }

  public inline function new(styles) {
    this = styles;
  }

  public inline function add(style:VStyle) {
    if (style != null && !this.contains(style))
      this.push(style);
    return this;
  }

  @:to public function toVStyle():VStyle {
    return if (this.length == 1) 
      this[0];
    else
      VStyleList(this);
  }

  @:to public function getName():String {
    return getNames().join(' ');
  }

  public function getNames() {
    return this.map(style -> switch style {
      case VStyleDef(type, props, suffix): 
        type.__generateName(props, suffix);
      case VStyleList(styles): 
        new StyleList(styles).getName();
    });
  }
}
