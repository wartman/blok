package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;
using blok.core.BuilderHelpers;

// @todo: There is a lot of coppied code with ComponentBuilder here:
//        try to DRY it up.
// @todo: I am becoming increasingly unsure about this approach. We may
//        need a more robust observable impl, or we might want to remove
//        sub states (which add a LOT of complexity).
class StateBuilder {
  static final PROPS = '__props';
  static final INCOMING_PROPS = '__incomingProps';
  static final OPTIONAL_META =  { name: ':optional', pos: (macro null).pos };
  
  public static function build(nodeTypeName:String) {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsName = cls.pack.concat([cls.name]).join('.');
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var builder = new ClassBuilder(cls, fields);
    var props:Array<Field> = [];
    var updateProps:Array<Field> = [];
    var updates:Array<Expr> = [];
    var initializers:Array<ObjectField> = [];
    var subStates:Array<Expr> = [];
    var initHooks:Array<Expr> = [];
    var disposals:Array<Expr> = [];
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

    builder.addFieldMetaHandler({
      name: 'prop',
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

    // This works, but is way too complex.
    builder.addFieldMetaHandler({
      name: 'state',
      options: [],
      hook: Init,
      build: function(options:{}, builder, field) switch field.kind {
        case FVar(t, e):
          if (!Context.unify(t.toType(), Context.getType('blok.core.State'))) {
            Context.error('Must be a `blok.core.State`', field.pos);
          }
          if (e != null) {
            Context.error('Expressions are not allowed for @state vars', e.pos);
          }

          if (!field.access.contains(APublic)) {
            field.access.remove(APrivate);
            field.access.push(APublic);
          }
          field.kind = FProp('get', 'never', t, null);

          var name = field.name;
          var getName = 'get_${name}';
          var lazyInit = '__state_${name}';
          var cls = t.toType().getClass();
          var tp:TypePath = {
            pack: cls.pack,
            name: cls.name
          };
          var tParams = switch t.toType() {
            case TInst(t, params): params;
            default: [];
          }
          var params = cls.params;
          var paramMap:Map<String, haxe.macro.Type> = [];
          var constructor = cls.constructor.get();
          var stateProps:Array<Field> = [];
          var ct = switch constructor.type {
            case TLazy(f): f();
            default: constructor.type;
          }

          for (i in 0...tParams.length) {
            var impl = tParams[i];
            var name = params[i].t.toString();
            paramMap.set(name, impl);
          }

          switch ct {
            case TFun(args, _):
              switch args[0].t {
                case TAnonymous(fields):
                  for (field in fields.get().fields) {
                    var type = field.type.mapTypes(paramMap);
                    stateProps.push({
                      name: field.name,
                      meta: field.meta.has(':optional')
                        ? [ { name: ':optional', pos: (macro null).pos } ]
                        : [],
                      kind: FVar(type.toComplexType()),
                      pos: (macro null).pos
                    });
                  }
                default: throw 'assert';
              }
            default: 
              throw 'assert';
          }

          var anon = TAnonymous(stateProps);
          props.push({
            name: name,
            kind: FVar(anon.toType().toComplexType(), null),
            access: [ APublic ],
            meta: [],
            pos: (macro null).pos
          });
          initializers.push({
            field: name,
            expr: macro $i{INCOMING_PROPS}.$name
          });

          var updateCalls:Array<Expr> = [];
          var updateMethods = TAnonymous(cls.fields.get()
            .filter(f -> f.meta.has('update') && f.isPublic)
            .map(f -> {
              var methodName = f.name;
              var fType = switch f.type {
                case TLazy(f): f();
                default: f.type;
              }
              var argProps:Array<Field> = switch fType {
                case TFun(args, _): args.map(a -> ({
                    name: a.name,
                    meta: a.opt
                      ? [ OPTIONAL_META ]
                      : [],
                    pos: (macro null).pos,
                    kind: FVar(a.t.mapTypes(paramMap).toComplexType())
                  }:Field));
                default: throw 'assert';
              };
              var type = argProps.length > 0 
                ? TAnonymous(argProps)
                : macro:Bool;
              var arguments:Array<Expr> = argProps.length > 0 
                ? [ for (arg in argProps) {
                    var n = arg.name;
                    macro __calls.$methodName.$n;
                  } ]
                : [];

              if (argProps.length > 0)
                updateCalls.push(macro {
                  if (__calls.$methodName != null) {
                    this.$name.$methodName($a{arguments});
                  }
                });
              else
                updateCalls.push(macro {
                  if (__calls.$methodName == true) {
                    this.$name.$methodName();
                  }
                });

              return ({
                name: f.name,
                kind: FVar(type),
                access: [APublic],
                meta: [OPTIONAL_META],
                pos: (macro null).pos
              }:Field);
            }));

          updateProps.push({
            name: name,
            kind: FVar(updateMethods),
            access: [APublic],
            meta: [OPTIONAL_META],
            pos: (macro null).pos
          });
          
          updates.push(macro {
            if (Reflect.hasField($i{INCOMING_PROPS}, $v{name})) {
              var __calls:$updateMethods = Reflect.field($i{INCOMING_PROPS}, $v{name});
              blok.core.State.__batchUpdate(this.$name, () -> $b{updateCalls});
            }
          });

          subStates.push(macro {
            var sub = this.$name;
            // @todo: subscribing to every change might be a bad idea?
            sub.__subscribe(this.__dispatch);
            this.__context.set(sub.__getId(), sub);
          });

          disposals.push(macro this.$name.__dispose());

          builder.add((macro class {
            var $lazyInit:$t;
            function $getName() {
              if (this.$lazyInit == null) {
                this.$lazyInit = new $tp($i{PROPS}.$name, __context, this, _->null);
              }
              return this.$lazyInit;
            }
          }).fields);
          
        default:
          Context.error('@state can only be used on vars', field.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'computed',
      hook: Normal,
      options: [],
      build: function (_, builder, f) switch f.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @computed vars', f.pos);
          }
  
          if (e == null) {
            Context.error('An expression is required for @computed', f.pos);
          }

          var name = f.name;
          var computeName = '__compute_${name}';
          var backingName = '__computedValue_${name}';
          var getName = 'get_${name}';

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

          // @todo: batch all computed subscriptions.
          initHooks.push(macro this.__subscribe(() -> this.$backingName = null));
          updates.push(macro @:pos(f.pos) this.$backingName = null);
          
        default:
          Context.error('@computed can only be used on vars', f.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'init',
      hook: After,
      options: [],
      build: function(_, builder, field) switch field.kind {
        case FFun(func):
          if (func.args.length > 0) {
            Context.error('@init methods cannot have any arguments', field.pos);
          }
          var name = field.name;
          initHooks.push(macro @:pos(field.pos) inline this.$name());
        default:
          Context.error('@init must be used on a method', field.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'update',
      hook: After,
      options: [
        { name: 'silent', optional: true }
      ],
      build: function (options:{ silent:Bool }, builder, field) switch field.kind {
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
                __dispatch();
              }
            }
          }
        default:
          Context.error('@update must be used on a method', field.pos);
      }
    });

    builder.addFields(() -> {
      var propType = TAnonymous(props);
      var createParams = cls.params.length > 0
        ? [ for (p in cls.params) { name: p.name, constraints: BuilderHelpers.extractTypeParams(p) } ]
        : [];
      var type = Context.getType(clsName);
      var nodeType = Context.getType(nodeTypeName).toComplexType();
      var ct = (switch type {
        case TInst(t, _): haxe.macro.Type.TInst(t, cls.params.map(f -> f.t));
        default: throw 'assert';
      }).toComplexType();
      var providerFactory = macro:(context:blok.core.Context<$nodeType>)->blok.core.VNode<$nodeType>;
      var subscriberFactory = macro:(data:$ct)->blok.core.VNode<$nodeType>;
  
      var newFields = ([

        {
          name: 'provide',
          pos: (macro null).pos,
          access: [ APublic, AStatic ],
          kind: FFun({
            params: createParams,
            ret: macro:blok.core.VNode<$nodeType>,
            args: [
              { name: 'context', type: macro:blok.core.Context<$nodeType> },
              { name: 'props', type: macro:$propType },
              { name: 'build', type: macro:$providerFactory  }
            ],
            expr: macro return VComponent({
              __create: function (props, context, parent) {
                var state = new $clsTp(props, context, parent, build);
                state.__inserted = true;
                return state;
              }
            }, props)
          })
        },

        {
          name: 'subscribe',
          pos: (macro null).pos,
          doc: '
Subscribe to this state\'s instance in the current context.

Whenever the state updtates the components returned by `build` will
be updated as well.

If you just want access to the current state, use 
`${clsName}.from(context)` instead.
          ',
          access: [ APublic, AStatic ],
          kind: FFun({
            params: createParams,
            ret: macro:blok.core.VNode<$nodeType>,
            args: [
              { name: 'context', type: macro:blok.core.Context<$nodeType> },
              { name: 'build', type: macro:$subscriberFactory }
            ],
            expr: macro {
              var state = from(context);
              return VComponent(blok.core.StateSubscriber, {
                state: state,
                build: build
              });
            }
          })
        },

        {
          name: 'from',
          pos: (macro null).pos,
          access: [ APublic, AStatic ],
          doc: '
Get the current instance of this state from the given context.

If you want to re-render whenever the state changes, use
`${clsName}.subscribe(context, state -> ...)` instead.
          ',
          kind: FFun({
            params: createParams,
            ret: ct,
            args: [
              { name: 'context', type: macro:blok.core.Context<$nodeType> },
            ],
            expr: macro {
              var state = context.get($v{id});
              #if debug
                if (state == null) {
                  throw 'The required state ' + $v{cls.pack.concat([cls.name]).join('.')} + ' was not provided.';
                }
              #end
              return state;
            }
          })
        }

      ]:Array<Field>).concat((macro class {
        var $PROPS:$propType;

        public function new($INCOMING_PROPS:$propType, __context, __parent, __build:$providerFactory) {
          this.__parent = __parent;
          this.__factory = cast __build;
          this.$PROPS = ${ {
            expr: EObjectDecl(initializers),
            pos: (macro null).pos
          } };
          __registerContext(__context);
          $b{initHooks};
          __render(this.__context);
        }

        override function __registerContext(context) {
          super.__registerContext(context);
          $b{subStates};
        }

        override function __getId() {
          return $v{id};
        }

        override function __dispose() {
          $b{disposals};
          super.__dispose();
        }

        @:noCompletion
        override function __updateProps($INCOMING_PROPS:Dynamic) {
          $b{updates};
        }
      }).fields);

      return newFields;
    });

    return builder.export();
  }
}
