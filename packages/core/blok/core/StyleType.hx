package blok.core;

typedef StyleType<Attrs:{}> = {
  public function __generateName(attrs:Attrs, suffix:Null<String>):String;
  public function __create(attrs:Attrs):Style;
}
