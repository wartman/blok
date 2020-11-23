package blok.core.style;

@:autoBuild(blok.core.style.StyleBuilder.build())
class Style {
  /**
    Define a style inline. This can be handy inside components, but it will NOT
    be updated if properties change.
  **/
  public static macro function define(e:haxe.macro.Expr.ExprOf<blok.core.style.StyleExpr>) {
    var name = haxe.macro.TypeTools.toString(haxe.macro.Context.getLocalType());
    var min = haxe.macro.PositionTools.getInfos(e.pos).min;
    return macro blok.core.style.VStyle.VStyleInline($v{name + ' { @' + min + ' }'}, () -> ${e});
  }

  public function getId():String {
    return '';
  }

  public function render():StyleExpr {
    return ENone;
  }
}
