package blok.core;

@:forward(contains, iterator, length)
abstract StyleList(Array<VStyle>) from Array<VStyle> to Array<VStyle> {
  @:from public inline static function ofStyleType(style:VStyle):StyleList {
    return [style];
  }

  public inline function new(styles) {
    this = styles;
  }

  /**
    Combine styles.

    Note: this does not modify the current StyleList -- instead, it will
    return a new one.
  **/
  public inline function add(style:VStyle):StyleList {
    if (style != null && !this.contains(style))
      return this.concat([ style ]);
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
      case VStyleInline(name, def):
        name;
      case VStyleList(styles): 
        new StyleList(styles).getName();
    });
  }
}
