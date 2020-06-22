package blok.core;

@:autoBuild(blok.core.StateBuilder.build())
@:access(blok.core.IsolateComponent)
class State {

  public var __alive:Bool = true;
  public var __dirty:Bool = false;
  public var __inserted:Bool = false;
  var __localContext:Context;
  var __factory:(context:Context)->VNode;
  var __parent:Wire;
  var __handler:IsolateComponent;
  var __subscribers:Array<()->Void> = [];

  public function __subscribe(listener:()->Void) {
    __subscribers.push(listener);
    return () -> __subscribers.remove(listener);
  }

  function __getId():String {
    return ''; // Handled by macro.
  }

  public function __getManagedNodes():Array<Node> {
    if (__handler == null) return [];
    return __handler.__getManagedNodes();
  }

  function __updateProps(_:Dynamic) {
    // noop
  }

  function __dispatch() {
    for (sub in __subscribers) sub();
  }

  function __register(context:Context) {
    __localContext = context.getChild();
    __localContext.set(__getId(), this);
    return __localContext;
  }

  public function __update(props:Dynamic, context:Context, parent:Wire):Void {
    __parent = parent;

    __updateProps(props);
    __render(context);
  }

  public function __dispose():Void {
    __alive = false;
    __handler.__dispose();
    __handler = null;
    __localContext = null;
    __subscribers = null;
  }

  public function __render(context:Context):Void {
    if (__handler == null) {
      __handler = new IsolateComponent(
        { children: [ __factory(__register(context)) ] },
        __localContext, 
        __parent
      );
    } else {
      __handler.__render(__register(context));
    }
  }

  public function __enqueuePendingChild(child:Wire):Void {
    if (__handler == null) return;
    __handler.__enqueuePendingChild(child);
  }

  public function __dequeuePendingChildren():Void {
    if (__handler == null) return;
    __handler.__dequeuePendingChildren();
  }

  public function __requestUpdate() {
    if (__handler == null) return;
    __handler.__requestUpdate();
  }

}
