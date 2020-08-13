package blok.internal;

import haxe.DynamicAccess;
import haxe.ds.Option;

using blok.internal.RenderedTools;

class Differ<Node> {
  static final EMPTY = {};

  public function new() {}
  
  public function diffObject(
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

  public function render(
    node:Node, 
    nodes:Array<VNode<Node>>,
    parent:Component<Node>,
    context:Context<Node>
  ) {
    var engine = context.engine;
    var previousCount = 0;
    var rendered = switch engine.getRendered(node) {
      case null: 
        renderAll(nodes, parent, context);
      case before: 
        previousCount = before.getNodes().length;
        updateAll(before, nodes, parent, context);
    }
    engine.setRendered(node, rendered);
    setChildren(previousCount, engine.traverseChildren(node), rendered);
  }

  public function renderAll(
    nodes:Array<VNode<Node>>,
    parent:Component<Node>,
    context:Context<Node>
  ):Rendered<Node> {
    var differ = createDiffer((_, _) -> None);
    return differ(nodes, parent, context);
  }

  public function updateAll(
    before:Rendered<Node>,
    nodes:Array<VNode<Node>>,
    parent:Component<Node>,
    context:Context<Node>
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
    before.dispose(context);

    return result;
  }

  public function setChildren(
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

  function createDiffer(previous:(type:Dynamic, key:Key)->Option<RNode<Node>>) {
    return function differ(
      nodes:Array<VNode<Node>>,
      parent:Component<Node>,
      context:Context<Node>
    ):Rendered<Node> {
      var result:Rendered<Node> = {
        types: [],
        children: []
      };
      
      function process(nodes:Array<VNode<Node>>, context:Context<Node>) {
        if (nodes != null) for (n in nodes) if (n != null) {
          inline function add(?key:Key, type:Dynamic, r:RNode<Node>) {
            if (!result.types.exists(type)) {
              result.types.set(type, new TypeRegistry());
            }
            result.types.get(type).put(key, r);
            result.children.push(r);
          }

          switch n {
            case VNative(type, props, styles, ref, key, children): switch previous(type, key) {
              case None:
                var node = type.create(props, context);
                render(node, children, parent, context);
                if (styles != null) context.engine.applyStyles(node, styles);
                if (ref != null) context.addEffect(() -> ref(node));
                add(key, type, RNative(node, props));
              case Some(r): switch r {
                case RNative(node, lastProps):
                  type.update(node, lastProps, props, context);
                  render(node, children, parent, context);
                  if (styles != null) context.engine.applyStyles(node, styles);
                  add(key, type, RNative(node, props));
                default: throw 'assert';
              }
              default: throw 'assert';
            }
            
            case VComponent(type, attrs, key): switch previous(type, key) {
              case None:
                var component = type.__create(attrs, context, parent);
                add(key, type, RComponent(component));
              case Some(r): switch r {
                case RComponent(component):
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
              process(children, context);
          }
          
        }
      }

      process(nodes, context);
      return result;
    }
  }
}
