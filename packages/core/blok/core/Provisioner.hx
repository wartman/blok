package blok.core;

typedef ProvisionerFunction<Node> = (context:Context<Node>)->Void; 

abstract Provisioner<Node>(ProvisionerFunction<Node>) from ProvisionerFunction<Node> {
  @:from public inline static function ofArray<Node>(items:Array<Provisioner<Node>>) {
    return new Provisioner(context -> for (p in items) p.register(context));
  }

  @:from public inline static function ofMap<Node>(items:Map<String, Dynamic>):Provisioner<Node> {
    return new Provisioner(context -> for (k => v in items) context.set(k, v));
  }

  @:from public inline static function ofState<Node>(item:State<Node>) {
    return new Provisioner(item.__register);
  }
  
  public inline function new(func) {
    this = func;
  }

  public inline function register(context) {
    this(context);
  }
}
