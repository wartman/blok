package blok.core;

interface PluginPayload<T> {
  public final key:String;
  public final value:T;
  public var handled:Bool;
}
