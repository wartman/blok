package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;
import blok.core.ClassBuilder;

using haxe.macro.Tools;

// @todo: dry with ComponentBuilder
class StateBuilder {

  static final PROPS = '__props';
  static final INCOMING_PROPS = '__incomingProps';
  static final OPTIONAL_META =  { name: ':optional', pos: (macro null).pos };
  
  public static function build() {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsName = cls.pack.concat([cls.name]).join('.');
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var builder = new ClassBuilder(fields, cls);
    var props:Array<Field> = [];
    var updateProps:Array<Field> = [];
    var updates:Array<Expr> = [];
    var initializers:Array<ObjectField> = [];
    var id = cls.pack.concat([ cls.name ]).join('_').toLowerCase();

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

          if (!f.access.contains(APublic)) {
            f.access.remove(APrivate);
            f.access.push(APublic);
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
      name: 'computed',
      similarNames: [ ':computed' ],
      multiple: false,
      hook: Normal,
      options: [],
      build: function (options:{}, builder, f) switch f.kind {
        case FVar(t, e):
          var name = f.name;
          var computeName = '__compute_${name}';
          var backingName = '__computedValue_${name}';
          var getName = 'get_${name}';

          if (t == null) {
            Context.error('Types cannot be inferred for @computed vars', f.pos);
          }
  
          if (e == null) {
            Context.error('An expression is required for @computed', f.pos);
          }

          f.kind = FProp('get', 'never', t, null);

          if (!f.access.contains(APublic)) {
            f.access.remove(APrivate);
            f.access.push(APublic);
          }

          builder.add((macro class {
  
            var $backingName:$t = null;
  
            function $computeName() {
              return ${e};
            }
  
            function $getName() {
              if (this.$backingName == null) {
                this.$backingName = this.$computeName();
              }
              return this.$backingName;
            }
  
          }).fields);

          updates.push(macro @:pos(f.pos) this.$backingName = null);
          
        default:
          Context.error('@computed can only be used on vars', f.pos);
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
                __updateProps(incoming);
                trace($i{PROPS});
                __dispatch();
              }
            }
          }
        default:
          Context.error('@update must be used on a method', field.pos);
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
    var type = Context
      .getType(clsName)
      .toComplexType();
    var providerFactory = macro:(context:blok.core.Context)->blok.core.VNode;
    var consumerFactory = macro:(data:$type)->blok.core.VNode;

    builder.add((macro class {

      public static function provide(
        context:blok.core.Context, 
        props:$propType,
        build:$providerFactory
      ):VNode {
        return VWidget({
          __create: function (props, context, parent) {
            var state = new $clsTp(props, context, parent, build);
            state.__inserted = true;
            return state;
          }
        }, props);
      }

      public static function consume(
        context:blok.core.Context,
        build:$consumerFactory
      ):VNode {
        var state = context.get($v{id});
        if (state == null) {
          throw 'The required state ' + $v{cls.pack.concat([cls.name]).join('.')} + ' was not provided.';
        }
        return blok.core.StateConsumer.node({
          state: state,
          build: build
        });
      }

      var $PROPS:$propType;

      public function new($INCOMING_PROPS:$propType, __context, __parent, __build:$providerFactory) {
        this.__parent = __parent;
        this.__factory = cast __build;
        this.$PROPS = ${ {
          expr: EObjectDecl(initializers),
          pos: (macro null).pos
        } };
        __register(__context);
        __render();
      }

      override function __getId() {
        return $v{id};
      }

      @:noCompletion
      override function __updateProps($INCOMING_PROPS:Dynamic) {
        $b{updates};
      }

    }).fields);


    return builder.export();
  }

}
