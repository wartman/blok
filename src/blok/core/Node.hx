package blok.core;

import blok.core.Rendered;

typedef Node = {
  public var __rendered:Null<Rendered>;
  public var parentNode:Node;
  public var nextSibling:Node;
  public var firstChild:Node;
  public function setAttribute(name:String, value:String):Void;
  public function getAttribute(key:String):String;
  public function removeAttribute(key:String):Void;
  public function appendChild(child:Node):Void;
  public function insertBefore(child:Node, ?ref:Node):Void;
  public function replaceChild(child:Node, ref:Node):Void;
  public function removeChild(child:Node):Void;
  public function remove():Void;
}
