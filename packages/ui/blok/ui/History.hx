package blok.ui;

interface History {
  public function getLocation():String;
  public function previous():Null<String>;
  public function next():Null<String>;
  public function push(url:String):Void;
}
