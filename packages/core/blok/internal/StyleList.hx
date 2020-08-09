package blok.internal;

@:forward(contains, iterator)
abstract StyleList(Array<Style>) from Array<Style> to Array<Style> {
  @:from public static function ofStyle(style:Style):StyleList {
    return [style];
  }

  public inline function new(styles) {
    this = styles;
  }

  public inline function add(style:Style) {
    if (style != null && !this.contains(style))
      this.push(style);
    return this;
  }

  public inline function toString() {
    return [for (s in this) s.getName()].filter(n -> n != null).join(' ');
  }
}
