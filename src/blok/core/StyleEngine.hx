package blok.core;

interface StyleEngine {
  public function exists(name:String):Bool;
  public function define(name:String, css:()->String):Void;
}
