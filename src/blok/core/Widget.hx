package blok.core;

typedef Widget = {
  var __alive:Bool;
  var __dirty:Bool;
  var __inserted:Bool;
  function __getManagedNodes():Array<Node>;
  function __update(props:Dynamic, context:Context, parent:Widget):Void;
  function __dispose():Void;
  function __doRender():Void;
  function __enqueuePendingChild(child:Widget):Void;
  function __dequeuePendingChildren():Void;
}
