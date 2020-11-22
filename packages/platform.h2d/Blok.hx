@:noUsing @:noDoc typedef Context = blok.Context;
@:noUsing @:noDoc typedef Platform = blok.h2d.Platform;
@:noUsing @:noDoc typedef Component = blok.Component;
@:noUsing @:noDoc typedef State = blok.State;
@:noUsing @:noDoc typedef Record = blok.core.Record; 

@:noUsing @:noDoc typedef VNode = blok.VNode;

@:noUsing @:noDoc typedef Ui = blok.h2d.Ui;

#if blok.core.style
  @:noUsing @:noDoc typedef Style = blok.style.Style;
  @:noUsing @:noDoc typedef StyleList = blok.style.StyleList;
  @:noUsing @:noDoc typedef VStyle = blok.style.VStyle;
  @:noUsing @:noDoc typedef VStyleExpr = blok.style.VStyle.VStyleExpr;
  @:noUsing @:noDoc typedef Unit = blok.style.VStyle.Unit;
  @:noUsing @:noDoc typedef Value = blok.style.VStyle.Value;
#end
