package blok.core;

typedef Wire = {
  var __alive:Bool;
  var __dirty:Bool;
  var __inserted:Bool;
  function __getManagedNodes():Array<Node>;
  function __update(props:Dynamic, context:Context, parent:Wire):Void;
  function __render(context:Context):Void;
  function __dispose():Void;
  function __enqueuePendingChild(child:Wire):Void;
  function __dequeuePendingChildren():Void;
}
