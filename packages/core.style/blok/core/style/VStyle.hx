package blok.core.style;

enum VStyle {
  VStyleDef<Props:{}>(type:StyleType<Props>, ?props:Props);
  VStyleInline(name:String, ?def:()->StyleExpr);
  VStyleList(styles:Array<VStyle>);
}
