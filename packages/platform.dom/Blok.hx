@:noUsing @:noDoc typedef Context = blok.Context;
@:noUsing @:noDoc typedef Platform = blok.dom.Platform;
@:noUsing @:noDoc typedef Component = blok.Component;
@:noUsing @:noDoc typedef Provider<T> = blok.core.Provider<T, js.html.Node>;
@:noUsing @:noDoc typedef Record = blok.core.Record; 

@:noUsing @:noDoc typedef State = blok.State;
@:noUsing @:noDoc typedef Observable<T> = blok.core.Observable<T>;
@:noUsing @:noDoc typedef ObservableSubscriber<T> = blok.ObservableSubscriber<T>;

@:noUsing @:noDoc typedef VNode = blok.VNode;

@:noUsing @:noDoc typedef Html = blok.html.Html;

#if blok.core.style
  @:noUsing @:noDoc typedef StyleList = blok.style.StyleList;
  @:noUsing @:noDoc typedef Style = blok.style.Style;
  @:noUsing @:noDoc typedef VStyle = blok.style.VStyle;
  @:noUsing @:noDoc typedef VStyleExpr = blok.style.VStyle.VStyleExpr;
  @:noUsing @:noDoc typedef Unit = blok.style.VStyle.Unit;
  @:noUsing @:noDoc typedef Value = blok.style.VStyle.Value;

  @:noUsing @:noDoc typedef Css = blok.html.Css;
#end

