package blok.core;

typedef ProvidableFunction<Node> = (context:Context<Node>)->Void; 

abstract Providable<Node>(ProvidableFunction<Node>) from ProvidableFunction<Node> {
  @:from public inline static function ofArray<Node>(items:Array<Providable<Node>>) {
    return new Providable(context -> for (p in items) p.register(context));
  }

  @:from public inline static function ofMap<Node>(items:Map<String, Dynamic>):Providable<Node> {
    return new Providable(context -> for (k => v in items) context.set(k, v));
  }

  @:from public inline static function ofState<Node>(item:State<Node>) {
    return new Providable(item.__register);
  }
  
  public inline function new(func) {
    this = func;
  }

  public inline function register(context) {
    this(context);
  }
}
