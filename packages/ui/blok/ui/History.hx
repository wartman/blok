package blok.ui;

import blok.core.Observable;

interface History {
  public function observe():Observable<String>;
  public function getLocation():String;
  public function previous():Null<String>;
  public function next():Null<String>;
  public function push(url:String):Void;
}
