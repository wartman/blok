package blok.core.foundation.routing;

using Blok;

interface History {
  public function getObservable():Observable<String>;
  public function getLocation():String;
  public function previous():Null<String>;
  public function next():Null<String>;
  public function push(url:String):Void;
}
