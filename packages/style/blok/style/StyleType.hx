package blok.style;

typedef StyleType<Props:{}> = {
  public function __generateName(props:Props, suffix:Null<String>):String;
  public function __create(props:Props):Style;
}
