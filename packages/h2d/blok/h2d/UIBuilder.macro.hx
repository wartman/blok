package blok.h2d;

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.TypeTools;

class UiBuilder {
  public static function build(types:Array<String>) {
    var fields = Context.getBuildFields();
    var requiredProps = false;

    for (t in types) switch Context.getType(t) {
      case TInst(t, params):
        var cls = t.get();
        var fields = cls.fields;
        // todo
      default:
    }

    for (typeName in types) {
      var type = Context.getType(typeName);
      var pack = typeName.split('.');
      var name = pack.pop();
      var fnName = name.charAt(0).toLowerCase() + name.substr(1);
      var objectTypeName = '__type_${fnName}';
      var tp:TypePath = {
        pack: pack,
        name: name
      };

      var constructor = type.getClass().constructor.get();
      var propsFields:Array<Field> = [];
      var conProps:Array<String> = [];
      var conArgs:Array<Expr> = [];

      function scanFields(cls:haxe.macro.Type.ClassType) {
        for (field in cls.fields.get()) 
          if (field.isPublic && !field.isFinal) switch field.kind {
            case FVar(_, AccNormal | AccCall):
              propsFields.push({
                name: field.name,
                kind: FVar(field.type.toComplexType(), null),
                pos: (macro null).pos,
                meta: [ { name: ':optional', pos: (macro null).pos } ]
              });
            case FMethod(MethDynamic):
              propsFields.push({
                name: field.name,
                kind: FVar(field.type.toComplexType(), null),
                pos: (macro null).pos,
                meta: [ { name: ':optional', pos: (macro null).pos } ]
              });
            default:
          }
        if (cls.superClass != null) {
          scanFields(cls.superClass.t.get());
        }
      }
      scanFields(type.getClass());
      
      var ct = switch constructor.type {
        case TLazy(f): f();
        default: constructor.type;
      }

      switch ct {
        case TFun(args, _): for (a in args) {
          var name = a.name;
          if (!a.opt) requiredProps = true;
          conProps.push(name);

          propsFields = propsFields.filter(p -> p.name != a.name);
          propsFields.push({
            name: a.name,
            kind: FVar(a.t.toComplexType(), null),
            pos: (macro null).pos,
            meta: a.opt ? [ { name: ':optional', pos: (macro null).pos } ] : []
          });

          conArgs.push(macro props.$name);
        }
        default:
      }
        
      var props = TAnonymous(propsFields);

      var build:Array<Expr> = [ for (prop in propsFields) {
        if (conProps.contains(prop.name)) {
          null;
        } else {
          var name = prop.name;
          macro if (props.$name != null) obj.$name = props.$name;
        }
      } ].filter(f -> f != null);
      
      fields = fields.concat((macro class {
        static final $objectTypeName = new ObjectType(props -> {
          var obj = new $tp($a{conArgs});
          $b{build};
          return obj;
        });
        public static function $fnName(props:{
          props:$props,
          ?style:blok.core.StyleList,
          ?ref:(obj:h2d.Object)->Void,
          ?key:blok.core.Key,
          ?children:Array<blok.core.VNode<h2d.Object>>
        }):blok.core.VNode<h2d.Object> {
          return VNative($i{objectTypeName}, props.props, props.style, props.ref, props.key, props.children);
        }
      }).fields);
    }

    return fields;
  }
}
