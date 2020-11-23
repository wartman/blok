package blok.core.style;

enum StyleExpr {
  ENone;
  EProperty<T>(name:String, value:T, ?important:Bool);
  EChildren(exprs:Array<StyleExpr>);
  ERaw(style:String);
  EScope(scope:StyleExprScope, expr:StyleExpr);
}

enum StyleExprScope {
  SGlobal;
  SWrapper(scopeName:String);
  SChild(name:String);
  SModifier(name:String);
}
