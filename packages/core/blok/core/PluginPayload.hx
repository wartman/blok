package blok.core;

private typedef PluginPayloadImpl<T> = {
  public final key:String;
  public final value:T;
}

@:forward(key, value)
abstract PluginPayload<T>(PluginPayloadImpl<T>) from PluginPayloadImpl<T> {
  public inline function new(key, value) {
    this = {
      key: key,
      value: value
    };
  }
}
