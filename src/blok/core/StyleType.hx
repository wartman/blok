package blok.core;

import blok.core.VStyle;

typedef StyleType<Attrs:{}> = {
  public function __generateName(attrs:Attrs, suffix:Null<String>):String;
  public function __render(attrs:Attrs, suffix:Null<String>):VStyleDecl;
}
