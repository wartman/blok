package blok.style;

import blok.style.VStyle;

typedef StyleType<Props:{}> = {
  public function getStyleName(props:Props, suffix:Null<String>):String;
  public function renderStyle(props:Props):Array<VStyleExpr>;
}
