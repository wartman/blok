package blok.core;

interface Cursor {
  public function insert(node:Node):Bool;
  public function step():Bool;
  public function delete():Bool;
  public function current():Node;
}
