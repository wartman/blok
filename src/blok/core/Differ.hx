package blok.core;

import haxe.DynamicAccess;
import haxe.ds.Option;

class Differ {

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
    nodes:Array<VNode>,
    parent:Wire,
    context:Context
  ) {
    var previousCount = 0;
    node.__rendered = switch node.__rendered {
      case null:
        renderAll(nodes, parent, context);
      case before:
        for (t in before.types) t.each(n -> previousCount++);
        updateAll(before, nodes, parent, context);
    }
    setChildren(
      previousCount,
      context.engine.traverseChildren(node),
      node.__rendered
    );
  }

  public function renderAll(
    nodes:Array<VNode>, 
    parent:Wire,
    context:Context
  ) {
    var differ = createDiffer((_, _) -> None);
    return differ(nodes, parent, context);
  }

  public function updateAll(
    before:Rendered,
    nodes:Array<VNode>,
    parent:Wire,
    context:Context
  ) {
    var differ = createDiffer((type, key) -> {
      var registry = before.types.get(type);
      if (registry == null) return None;
      return switch registry.pull(key) {
        case null: None;
        case v: Some(v);
      }
    });
    
    var result = differ(nodes, parent, context);

    for (r in before.types) r.each(c -> c.__dispose());

    return result;
  }

  public function setChildren(
    previousCount:Int,
    cursor:Cursor,
    next:Rendered
  ) {
    var insertedCount = 0;
    var currentCount = 0;

    for (widget in next.children) for (node in widget.__getManagedNodes()) {
      currentCount++;
      if (node == cursor.current()) cursor.step();
      else if (cursor.insert(node)) insertedCount++;
    }

    var deleteCount = previousCount + insertedCount - currentCount;
    
    for (i in 0...deleteCount) {
      if (!cursor.delete()) break;
    }
  }

  function createDiffer(previous:(type:WireType<Dynamic>, key:Key)->Option<Wire>) {
    return function differ(
      nodes:Array<VNode>,
      parent:Wire,
      context:Context
    ):Rendered {
      var result:Rendered = {
        types: [],
        children: []
      };
      
      function process(nodes:Array<VNode>, context:Context) {
        if (nodes != null) for (n in nodes) if (n != null) {

          inline function add(?key:Key, type:WireType<Dynamic>, c:Wire) {
            if (!result.types.exists(type)) {
              result.types.set(type, new TypeRegistry());
            }
            result.types.get(type).put(key, c);
            result.children.push(c);
          }

          switch n {
            case VWire(type, attrs, key): switch previous(type, key) {
              case None:
                var widget = type.__create(attrs, context, parent);
                add(key, type, widget);
              case Some(widget):
                widget.__update(attrs, context, parent);
                add(key, type, widget);
              default:
                throw 'assert';
            }

            case VFragment(children, key):
              process(children, context);
          }
          
        }
      }

      process(nodes, context);
      return result;
    }
  }

}
