package blok.core.style;

typedef StyleType<Props:{}> = {
  public function getStyleId(props:Props):String;
  public function renderStyle(props:Props):StyleExpr;
}
