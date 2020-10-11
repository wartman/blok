package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;
using blok.core.BuilderHelpers;

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

          if (Context.unify(t.toType(), Context.getType('blok.core.Observable.ObservableTarget'))) {
            var linkName = '__link_${name}';
            builder.add((macro class {
              var $linkName:blok.core.Observable.Observer<Dynamic>;
            }).fields);
            init = macro {
              var value = ${init};
              this.$linkName = (value:ObservableTarget<Dynamic>).observe(_ -> __notify());
              value;
            }
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
                    this.$linkName.cancel();
                    this.$PROPS.$name = value;
                    this.$linkName = (this.$PROPS.$name:ObservableTarget<Dynamic>).observe(_ -> __notify());
                }
              }
            });
          } else {
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
                    this.__dirty = true;
                    this.$PROPS.$name = value;
                }
              }
            });
          }

        default:
          Context.error('@prop can only be used on vars', f.pos);
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

          // @todo: this kills completion.
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
          initHooks.push(macro this.__observable.observe(_ -> this.$backingName = null));
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
      options: [],
      build: function (_, builder, field) switch field.kind {
        case FFun(func):
          if (func.ret != null) {
            Context.error('@update functions should not define their return type manually', field.pos);
          }
          var updatePropsRet = TAnonymous(updateProps);
          var e = func.expr;

          func.ret = macro:Void;
          
          func.expr = macro {
            inline function closure():blok.core.UpdateMessage<$updatePropsRet> ${e};
            switch closure() {
              case None | null:
              case Update:
                __notify();
              case UpdateState(data): 
                __updateProps(data);
                if (__dirty) {
                  __dirty = false;
                  __notify();
                }
              case UpdateStateSilent(data):
                __updateProps(data);
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
      var observerFactory = macro:(data:$ct)->blok.core.VNode<$nodeType>;
  
      var newFields = ([

        {
          name: 'provide',
          pos: (macro null).pos,
          access: [ APublic, AStatic ],
          kind: FFun({
            params: createParams,
            ret: macro:blok.core.VNode<$nodeType>,
            args: [
              { name: 'props', type: macro:$propType },
              { name: 'build', type: macro:$providerFactory  }
            ],
            expr: macro {
              var state = new $clsTp(props);
              return VComponent(blok.core.Provider, {
                // observable: state,
                key: $v{id},
                value: state,
                build: build
              });
            }
          })
        },

        {
          name: 'observe',
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
              { name: 'build', type: macro:$observerFactory }
            ],
            expr: macro {
              var state = from(context);
              return VComponent(blok.core.ObservableSubscriber, {
                observable: state,
                build: build
              });
            }
          })
        },

        {
          name: 'select',
          pos: (macro null).pos,
          doc: '
Subscribe to this state\'s instance in the current context.

Only update when the selected value is changed.
          ',
          access: [ APublic, AStatic ],
          kind: FFun({
            params: createParams.concat([ { name: 'R', constraints: [] } ]),
            ret: macro:blok.core.VNode<$nodeType>,
            args: [
              { name: 'context', type: macro:blok.core.Context<$nodeType> },
              { name: 'selector', type: macro:(state:$ct)->R },
              { name: 'build', type: macro:(data:R)->blok.core.VNode<$nodeType> }
            ],
            expr: macro {
              var state = from(context);
              return VComponent(blok.core.ObservableSubscriber, {
                observable: state.getObservable().select(selector),
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
`${clsName}.observe(context, state -> ...)` instead.
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
        var __dirty:Bool = false;
        final __observable:blok.core.Observable<$ct>;
        public final __id:String = $v{id};

        public function new($INCOMING_PROPS:$propType) {
          __observable = new blok.core.Observable(this, $v{id});
          this.$PROPS = ${ {
            expr: EObjectDecl(initializers),
            pos: (macro null).pos
          } };
          $b{initHooks};
        }

        public function getObservable():blok.core.Observable<$ct> {
          return __observable;
        }

        inline function __notify() {
          __observable.notify(this);
        }

        @:noCompletion
        function __updateProps($INCOMING_PROPS:Dynamic) {
          $b{updates};
        }
      }).fields);

      return newFields;
    });

    return builder.export();
  }
}
