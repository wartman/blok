package blok.component;

class Flow {
  static final type:ObjectType<{}> = new ObjectType(() -> new h2d.Flow());

  public static function node(props:{}):VNode {
    return VNative(type, props);
  }
}
