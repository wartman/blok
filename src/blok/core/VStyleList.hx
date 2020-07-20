package blok.core;

import blok.core.VStyle;

abstract VStyleList(Array<VStyleDecl>) from Array<VStyleDecl> to Array<VStyleDecl> {
  
  @:from public static function ofString(name:String) {
    return new VStyleList([ VClass(name, []) ]);
  }

  @:from public static function ofVStyleDecl(style:VStyleDecl) {
    return new VStyleList([ style ]);
  }

  public inline function new(list) {
    this = list;
  }

  public inline function add(style:VStyleDecl) {
    if (style != null) this.push(style);
    return this;
  }

  public inline function iterator() {
    return this.iterator();
  }

  public inline function toString() {
    return [ for (s in this) s.getName() ]
      .filter(n -> n != null)
      .join(' ');
  }

}
