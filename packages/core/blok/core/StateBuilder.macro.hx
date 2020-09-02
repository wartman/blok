package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;
using blok.core.BuilderHelpers;

// @TODO: There is a lot of coppied code with ComponentBuilder here:
//        try to DRY it up.
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
    var availableStates:Array<String> = [];
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

    // This handler is a work in progress. Mostly what I'm realizing
    // from it is that it will work a *lot* better if I'm doing it
    // with real reactive programing (like `tink_state`). Alternatively,
    // we might start using Signals here?
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
          var props:Array<Field> = [];
          var ct = switch constructor.type {
            case TLazy(f): f();
            default: constructor.type;
          }

          for (i in 0...tParams.length) {
            var impl = tParams[i];
            var name = params[i].t.toString();
            paramMap.set(name, impl);
          }

          availableStates.push(field.name);

          switch ct {
            case TFun(args, _):
              switch args[0].t {
                case TAnonymous(fields):
                  for (field in fields.get().fields) {
                    var type = field.type.mapTypes(paramMap);
                    props.push({
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

          // todo: we need to resolve params.
          var anon = TAnonymous(props);
          addProp(name, anon.toType().toComplexType(), false);
          initializers.push({
            field: name,
            expr: macro $i{INCOMING_PROPS}.$name
          });
          // dunno if this is a good way to do this. Probably not.
          updates.push(macro {
            if (Reflect.hasField($i{INCOMING_PROPS}, $v{name})) {
              var props:$anon = Reflect.field($i{INCOMING_PROPS}, $v{name});
              this.$name.__update(props, __context, this);
            }
          });
          subStates.push(macro {
            var sub = this.$name;
            // // For now, I'm *not* subscribing the parent state to the child.
            // // To propagate changes on the parent you'll need to use an @update
            // // method. 
            // sub.__subscribe(() -> __dispatch());
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

          updates.push(macro @:pos(f.pos) this.$backingName = null);
          
        default:
          Context.error('@computed can only be used on vars', f.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'subscribe',
      hook: After,
      options: [
        {
          name: 'target',
          optional: false,
          handleValue: expr -> switch expr.expr {
            case EConst(CIdent(s)) if (availableStates.contains(s)): s;
            case EConst(CIdent(s)) if (!availableStates.contains(s)):
              Context.error('[$s] is not a valid state. Available states are: [${availableStates.join(', ')}]', expr.pos);
              '';
            default:
              Context.error('Expected an identifier', expr.pos);
              '';
          }
        },
        
        {
          name: 'property',
          optional: true,
          handleValue: expr -> switch expr.expr {
            case EConst(CIdent(s)): s;
            default:
              Context.error('Expected an identifier', expr.pos);
              '';
          }
        }
      ],
      build: function(options:{ target:String, ?property:String }, builder, field) switch field.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @subscribe vars', field.pos);
          }
  
          if (e != null) {
            Context.error('An expression is not allowed for @subscribe', field.pos);
          }

          var name = field.name;
          var getName = 'get_${name}';
          var backingName = '__computedValue_${name}';
          var state = options.target;
          var stateProperty = options.property == null
            ? name
            : options.property;

          if (!field.access.contains(APublic)) {
            field.access.remove(APrivate);
            field.access.push(APublic);
          }

          field.kind = FProp('get', 'never', t, null);

          builder.add((macro class {
            var $backingName:$t = null;
            function $getName() return $i{backingName};
          }).fields);

          initHooks.push(macro {
            @:pos(field.pos) $i{backingName} = $i{state}.$stateProperty;
            $i{state}.__subscribe(() -> {
              if ($i{backingName} != $i{state}.$stateProperty) {
                $i{backingName} = $i{state}.$stateProperty;
                __dispatch();
              }
            });
          });

        default:
          // todo: allow `@subscribe` to be used on functions. This will
          //       work like `@update` I think.
          Context.error('@subscribe can only be used on vars', field.pos);
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
  
      var newFields:Array<Field> = [

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
          access: [ APublic, AStatic ],
          kind: FFun({
            params: createParams,
            ret: macro:blok.core.VNode<$nodeType>,
            args: [
              { name: 'context', type: macro:blok.core.Context<$nodeType> },
              { name: 'build', type: macro:$subscriberFactory }
            ],
            expr: macro {
              var state = forContext(context);
              return VComponent(blok.core.StateSubscriber, {
                state: state,
                build: build
              });
            }
          })
        },

        {
          name: 'forContext',
          pos: (macro null).pos,
          access: [ APublic, AStatic ],
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

      ].concat((macro class {
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
