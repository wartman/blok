package blok;

import haxe.ds.Map;
import js.Browser;
import js.html.Node;
import js.html.Element;

class NodeType<Props:{}> {
  public static inline final SVG_NS = 'http://www.w3.org/2000/svg';
  
  static var types:Map<String, NodeType<Dynamic>> = [];

  public static function get<Props:{}>(tag:String):NodeType<Props> {
    if (!types.exists(tag)) {
      types.set(tag, new NodeType(tag));
    }
    return cast types.get(tag);
  }

  public static function updateNodeAttribute(node:Node, name:String, oldValue:Dynamic, newValue:Dynamic):Void {
    var el:Element = cast node;
    var isSvg = el.namespaceURI == SVG_NS;
    switch name {
      case 'className':
        updateNodeAttribute(node, 'class', oldValue, newValue);
      case 'xmlns' if (isSvg): // skip
      case 'value' | 'selected' | 'checked' if (!isSvg):
        js.Syntax.code('{0}[{1}] = {2}', el, name, newValue);
      case _ if (!isSvg && js.Syntax.code('{0} in {1}', name, el)):
        js.Syntax.code('{0}[{1}] = {2}', el, name, newValue);
      default:
        if (name.charAt(0) == 'o' && name.charAt(1) == 'n') {
          var name = name.toLowerCase();
          if (newValue == null) {
            Reflect.setField(el, name, null);
          } else {
            Reflect.setField(el, name, newValue);
          }
          // var ev = key.substr(2).toLowerCase();
          // el.removeEventListener(ev, oldValue);
          // if (newValue != null) el.addEventListener(ev, newValue);
        } else if (newValue == null || (Std.is(newValue, Bool) && newValue == false)) {
          el.removeAttribute(name);
        } else if (Std.is(newValue, Bool) && newValue == true) {
          el.setAttribute(name, name);
        } else {
          el.setAttribute(name, newValue);
        }
    }
  }

  final tag:String;

  public function new(tag) {
    this.tag = tag;
  }
  
  public function create(props:Props, context:Context):Node {
    var node = Browser.document.createElement(tag);
    context.engine.differ.diffObject(
      {}, 
      props, 
      updateNodeAttribute.bind(node)
    );
    return node;
  }

  public function update(node:Node, previousProps:Props, props:Props, context:Context):Node {
    context.engine.differ.diffObject(
      previousProps, 
      props, 
      updateNodeAttribute.bind(node)
    );
    return node;
  }

}
