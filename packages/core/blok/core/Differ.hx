package blok.core;

import haxe.DynamicAccess;
import haxe.ds.Option;

typedef DifferHandler<Node> = (
  nodes:Array<VNode<Node>>,
  parent:Component<Node>,
  context:Context<Node>
) -> Rendered<Node>; 

/**
  Handles high-level diffing for VNodes.
  
  Like most of the diffing related code, the stuff in here is bascially
  copied from the Coconut project:
  
  https://github.com/MVCoconut/coconut.diffing
**/
class Differ {
  static final EMPTY = {};
  
  public static function diffObject<Node>(
    oldProps:DynamicAccess<Dynamic>,
    newProps:DynamicAccess<Dynamic>,
    apply:(key:String, oldValue:Dynamic, newValue:Dynamic)->Void
  ) {
    if (oldProps == newProps) return;

    var keys = (if (newProps == null) {
      newProps = EMPTY;
      oldProps;
    } else if (oldProps == null) {
      oldProps = EMPTY;
      newProps;
    } else {
      var ret = newProps.copy();
      for (key in oldProps.keys()) ret[key] = true;
      ret;
    }).keys();

    for (key in keys) switch [ oldProps[key], newProps[key] ] {
      case [ a, b ] if (a == b):
      case [ a, b ]: apply(key, a, b);
    }
  }

  public static function render<Node>(
    node:Node, 
    nodes:Array<VNode<Node>>,
    parent:Component<Node>,
    context:Context<Node>
  ) {
    var engine = context.engine;

    inline function handleRendered(previousCount, rendered) {
      engine.setRendered(node, rendered);
      setChildren(previousCount, engine.traverseChildren(node), rendered);
    }

    switch engine.getRendered(node) {
      case null: 
        renderAll(nodes, parent, context, rendered -> handleRendered(0, rendered));
      case before: 
        var previousCount = before.getNodes().length;
        updateAll(before, nodes, parent, context, rendered -> handleRendered(previousCount, rendered));
    }
  }

  public static function renderAll<Node>(
    nodes:Array<VNode<Node>>,
    parent:Component<Node>,
    context:Context<Node>,
    ?handle:(rendered:Rendered<Node>)->Void
  ):Rendered<Node> {
    var differ = createDiffer((_, _) -> None);
    var result = differ(nodes, parent, context);
    if (handle != null) handle(result);
    return result;
  }

  public static function updateAll<Node>(
    before:Rendered<Node>,
    nodes:Array<VNode<Node>>,
    parent:Component<Node>,
    context:Context<Node>,
    ?handle:(rendered:Rendered<Node>)->Void
  ):Rendered<Node> {
    var differ = createDiffer((type, key) -> {
      var registry = before.types.get(type);
      if (registry == null) return None;
      return switch registry.pull(key) {
        case null: None;
        case v: Some(v);
      }
    });
    var result = differ(nodes, parent, context);

    if (handle != null) handle(result);
    before.dispose(context);

    return result;
  }

  public static function setChildren<Node>(
    previousCount:Int,
    cursor:Cursor<Node>,
    next:Rendered<Node>
  ) {
    var insertedCount = 0;
    var currentCount = 0;

    for (node in next.getNodes()) {
      currentCount++;
      if (node == cursor.current()) cursor.step();
      else if (cursor.insert(node)) insertedCount++;
    }

    var deleteCount = previousCount + insertedCount - currentCount;
    
    for (i in 0...deleteCount) {
      if (!cursor.delete()) break;
    }
  }

  static function createDiffer<Node>(previous:(type:Dynamic, key:Key)->Option<RNode<Node>>):DifferHandler<Node> {
    return function differ(
      nodes:Array<VNode<Node>>,
      parent:Component<Node>,
      context:Context<Node>
    ):Rendered<Node> {
      var result:Rendered<Node> = {
        types: [],
        children: []
      };

      inline function add(?key:Key, type:{}, r:RNode<Node>) {
        if (!result.types.exists(type)) {
          result.types.set(type, new TypeRegistry());
        }
        result.types.get(type).put(key, r);
        result.children.push(r);
      }
      
      function process(nodes:Array<VNode<Node>>) {
        if (nodes != null) for (n in nodes) if (n != null) {
          switch n {
            case VNative(type, props, styles, ref, key, children): switch previous(type, key) {
              case None:
                context.onCreateVNode(n);
                var node = type.create(props, context);
                render(node, children, parent, context);
                if (ref != null) context.addEffect(() -> ref(node));
                add(key, type, RNative(node, props));
              case Some(r): switch r {
                case RNative(node, lastProps):
                  context.onUpdateVNode(n);
                  type.update(node, lastProps, props, context);
                  render(node, children, parent, context);
                  add(key, type, RNative(node, props));
                default: throw 'assert';
              }
              default: throw 'assert';
            }
            
            case VComponent(type, attrs, key): switch previous(type, key) {
              case None:
                context.onCreateVNode(n);
                var component = type.__create(attrs, context, parent);
                add(key, type, RComponent(component));
              case Some(r): switch r {
                case RComponent(component):
                  context.onUpdateVNode(n);
                  component.__update(attrs, context, parent);
                  add(key, type, RComponent(component));
                default:
                  throw 'assert';
              }
              default:
                throw 'assert';
            }

            case VFragment(children, key):
              // todo: handle key?
              process(children);
          }
        }
      }

      process(nodes);
      return result;
    }
  }
}
