package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;

class ComponentBuilder {

  static final PROPS = '__props';
  static final INCOMING_PROPS = '__incomingProps';
  static final OPTIONAL_META =  { name: ':optional', pos: (macro null).pos };
  
  public static function build() {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var builder = new ClassBuilder(fields, cls);
    var props:Array<Field> = [];
    var updateProps:Array<Field> = [];
    var updates:Array<Expr> = [];
    var initializers:Array<ObjectField> = [];
    var initHooks:Array<Expr> = [];
    var disposeHooks:Array<Expr> = [];
    var effectHooks:Array<Expr> = [];

    function addProp(name:String, type:ComplexType, isOptional:Bool) {
      props.push({
        name: name,
        kind: FVar(type, null),
        access: [ APublic ],
        meta: isOptional ? [ OPTIONAL_META ] : [],
        pos: (macro null).pos
      });
      updateProps.push({
        name: name,
        kind: FVar(type, null),
        access: [ APublic ],
        meta: [ OPTIONAL_META ],
        pos: (macro null).pos
      });
    }

    builder.addFieldBuilder({
      name: 'prop',
      similarNames: [
        'property', ':prop'
      ],
      multiple: false,
      hook: Normal,
      options: [],
      build: function (options:{}, builder, f) switch f.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @prop vars', f.pos);
          }

          var name = f.name;
          var getName = 'get_${name}';
          var init = e == null
            ? macro $i{INCOMING_PROPS}.$name
            : macro $i{INCOMING_PROPS}.$name == null ? ${e} : $i{INCOMING_PROPS}.$name;
          
          f.kind = FProp('get', 'never', t, null);

          builder.add((macro class {

            function $getName() return $i{PROPS}.$name;

          }).fields);

          addProp(name, t, e != null);
          initializers.push({
            field: name,
            expr: init
          });

          updates.push(macro {
            if (Reflect.hasField($i{INCOMING_PROPS}, $v{name})) {
              switch [
                $i{PROPS}.$name, 
                Reflect.field($i{INCOMING_PROPS}, $v{name}) 
              ] {
                case [ a, b ] if (a == b):
                  // noop
                case [ current, value ]:
                  $i{PROPS}.$name = value;
              }
            }
          });

        default:
          Context.error('@prop can only be used on vars', f.pos);
      }
    });

    builder.addFieldBuilder({
      name: 'update',
      similarNames: [ ':update' ],
      multiple: false,
      hook: After,
      options: [
        { name: 'silent', optional: true }
      ],
      build: function (options:{
        ?silent:Bool
      }, builder, field) switch field.kind {
        case FFun(func):
          if (func.ret != null) {
            Context.error('@update functions should not define their return type manually', field.pos);
          }
          var updatePropsRet = TAnonymous(updateProps);
          var e = func.expr;
          func.ret = macro:Void;
          if (options.silent == true) {
            func.expr = macro {
              inline function closure():$updatePropsRet ${e};
              var incoming = closure();
              if (incoming != null) {
                __updateProps(incoming);
              }
            }
          } else {
            func.expr = macro {
              inline function closure():$updatePropsRet ${e};
              var incoming = closure();
              if (incoming != null) {
                if (__shouldUpdate(incoming)) {
                  __updateProps(incoming);
                  __requestUpdate();
                }
              }
            }
          }
        default:
          Context.error('@update must be used on a method', field.pos);
      }
    });

    builder.addFieldBuilder({
      name: 'init',
      similarNames: [ ':init' ],
      multiple: false,
      options: [],
      hook: After,
      build: function (options:{}, builder, field) switch field.kind {
        case FFun(func):
          if (func.args.length > 0) {
            Context.error('@init methods cannot have any arguments', field.pos);
          }
          var name = field.name;
          initHooks.push(macro @:pos(field.pos) this.$name());
        default:
          Context.error('@init must be used on a method', field.pos);
      }
    });

    builder.addFieldBuilder({
      name: 'dispose',
      similarNames: [ ':dispose' ],
      multiple: false,
      options: [],
      hook: After,
      build: function (options:{}, builder, field) switch field.kind {
        case FFun(func):
          if (func.args.length > 0) {
            Context.error('@dispose methods cannot have any arguments', field.pos);
          }
          var name = field.name;
          disposeHooks.push(macro @:pos(field.pos) this.$name());
        default:
          Context.error('@dispose must be used on a method', field.pos);
      }
    });

    builder.addFieldBuilder({
      name: 'effect',
      similarNames: [ ':effect' ],
      multiple: false,
      options: [],
      hook: After,
      build: function (options:{}, builder, field) switch field.kind {
        case FFun(func):
          if (func.args.length > 0) {
            Context.error('@effect methods cannot have any arguments', field.pos);
          }
          var name = field.name;
          effectHooks.push(macro @:pos(field.pos) this.$name());
        default:
          Context.error('@effect must be used on a method', field.pos);
      }
    });

    builder.run();
    
    function extractTypeParams(tp:haxe.macro.Type.TypeParameter) {
      return switch tp.t {
        case TInst(kind, _): switch kind.get().kind {
          case KTypeParameter(constraints): constraints.map(t -> t.toComplexType());
          default: [];
        }
        default: [];
      }
    }

    var propType = TAnonymous(props);
    var createParams =  cls.params.length > 0
      ? [ for (p in cls.params) { name: p.name, constraints: extractTypeParams(p) } ]
      : [];
    var effects = effectHooks.length > 0 
      ? macro __context.addEffect(() -> $b{effectHooks})
      : macro null;


    builder.add([
      
      {
        name: '__create',
        pos: (macro null).pos,
        access: [ APublic, AStatic ],
        kind: FFun({
          params: createParams,
          args: [
            { name: 'props', type: macro:$propType },
            { name: 'context', type: macro:blok.core.Context },
            { name: 'parent', type: macro:blok.core.Widget }
          ],
          expr: macro @:pos(cls.pos) {
            var comp = new $clsTp(props, context, parent);
            comp.__inserted = true;
            return comp;
          },
          ret: macro:blok.core.Widget
        })
      },
      
      {
        name: 'node',
        access: [ AStatic, APublic, AInline ],
        pos: (macro null).pos,
        kind: FFun({
          ret: macro:blok.core.VNode,
          params: createParams,
          args: [
            { name: 'props', type: macro:$propType },
            { name: 'key', type: macro:Null<blok.core.Key>, opt: true }
          ],
          expr: macro @:pos(cls.pos) return blok.core.VNode.VWidget(
            $p{ cls.pack.concat([ cls.name ]) },
            props,
            key
          )
        })
      }

    ]);

    builder.add((macro class {

      var $PROPS:$propType;

      public function new($INCOMING_PROPS:$propType, __context, __parent) {
        this.__context = __context;
        this.__parent = __parent;
        this.$PROPS = ${ {
          expr: EObjectDecl(initializers),
          pos: (macro null).pos
        } };
        $b{initHooks}
        __render();
      }

      @:noCompletion
      override function __updateProps($INCOMING_PROPS:Dynamic) {
        $b{updates};
      }

      @:noCompletion
      override function __shouldUpdate($INCOMING_PROPS:Dynamic) {
        return true;
      }

      override function __registerEffects() {
        ${effects};
      }

      @:noCompletion
      override function __dispose() {
        $b{disposeHooks};
        super.__dispose();
      }

    }).fields);

    return builder.export();
  }

}