package blok.h2d;

@:forward(iterator)
abstract ClassList(Array<String>) {
  public function new() {
    this = [];
  }

  public function has(name:String) {
    return this.contains(name);
  }

  public function add(name:String) {
    if (!has(name)) this.push(name);
  }

  public function remove(name:String) {
    this.remove(name);
  }
}
