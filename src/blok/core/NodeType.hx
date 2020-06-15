package blok.core;

interface NodeType<Attrs:{}> {
  public function create(attrs:Attrs, context:Context):Node;
  public function update(node:Node, oldAttrs:Attrs, newAttrs:Attrs, context:Context):Void;
}
