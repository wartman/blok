package blok;

import haxe.ds.Map;
import blok.core.Differ;

class NodeType<Props:{}> {
  static var types:Map<String, NodeType<Dynamic>> = [];

  public static function get<Props:{}>(tag:String):NodeType<Props> {
    if (!types.exists(tag)) switch tag.split(':') {
      case ['svg', name]: types.set(tag, new NodeType(name));
      default: types.set(tag, new NodeType(tag));
    }
    return cast types.get(tag);
  }

  public static function updateNodeAttribute(node:Node, name:String, oldValue:Dynamic, newValue:Dynamic):Void {
    if (name.charAt(0) == 'o' && name.charAt(1) == 'n') {
      // noop
    } else if (name == 'className') {
      node.setAttribute('class', newValue);
    } else if (newValue == null || newValue == false) {
      node.removeAttribute(name);
    } else if (newValue == true) {
      node.setAttribute(name, name);
    } else {
      node.setAttribute(name, newValue);
    }
  }

  final tag:String;

  public function new(tag) {
    this.tag = tag;
  }
  
  public function create(props:Props, context:Context):Node {
    var node = new Node(tag);
    Differ.diffObject(
      {}, 
      props, 
      updateNodeAttribute.bind(node)
    );
    return node;
  }

  public function update(node:Node, previousProps:Props, props:Props, context:Context):Node {
    Differ.diffObject(
      previousProps, 
      props, 
      updateNodeAttribute.bind(node)
    );
    return node;
  }

}
