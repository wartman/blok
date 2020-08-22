package blok.ui;

class RouterState<T> extends State {
  @prop var matcher:(route:T)->Bool;

  public function match(path:T):Bool {
    return matcher(path);
  }
}
