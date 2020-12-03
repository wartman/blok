package blok.core;

interface State<Node> {
  public function __register(context:Context<Node>):Void;
}
