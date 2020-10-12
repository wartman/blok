package blok.core;

private typedef PluginPayloadImpl<T> = {
  public final key:String;
  public final value:T;
  public var handled:Bool;
}

@:forward(key, value, handled)
abstract PluginPayload<T>(PluginPayloadImpl<T>) from PluginPayloadImpl<T> {
  public inline function new(key, value, handled = false) {
    this = {
      key: key,
      value: value,
      handled: handled
    };
  }
}
