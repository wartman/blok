@:noUsing @:noDoc typedef Context = blok.Context;
@:noUsing @:noDoc typedef Platform = blok.dom.Platform;
@:noUsing @:noDoc typedef Component = blok.Component;
@:noUsing @:noDoc typedef Provider<T> = blok.core.Provider<T, js.html.Node>;
@:noUsing @:noDoc typedef Record = blok.core.Record; 

@:noUsing @:noDoc typedef State = blok.State;
@:noUsing @:noDoc typedef Observable<T> = blok.core.Observable<T>;
@:noUsing @:noDoc typedef ObservableSubscriber<T> = blok.ObservableSubscriber<T>;

@:noUsing @:noDoc typedef VNode = blok.VNode;

@:noUsing @:noDoc typedef Html = blok.core.html.Html;

#if blok.core.style
  @:noUsing @:noDoc typedef StyleList = blok.core.style.StyleList;
  @:noUsing @:noDoc typedef Style = blok.core.style.Style;
  @:noUsing @:noDoc typedef VStyle = blok.core.style.VStyle;
  @:noUsing @:noDoc typedef StyleExpr = blok.core.style.StyleExpr;

  @:noUsing @:noDoc typedef CssUnit = blok.core.html.CssUnit;
  @:noUsing @:noDoc typedef CssValue = blok.core.html.CssValue;
  @:noUsing @:noDoc typedef Css = blok.core.html.Css;
#end
