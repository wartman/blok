package blok.core;

import blok.core.VStyle.VStyleDecl;

interface StyleEngine {
  public function exists(name:String):Bool;
  public function define(name:String, css:()->VStyleDecl):Void;
}
