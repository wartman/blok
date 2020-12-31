package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;
import blok.core.BuilderHelpers.*;

using Lambda;
using haxe.macro.Tools;

class ComponentBuilder {
  public static function build(nodeTypeName:String) {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var builder = new ClassBuilder(cls, fields);
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

    builder.addClassMetaHandler({
      name: 'lazy',
      hook: After,
      options: [],
      build: function (options:{}, builder, fields) {
        if (fields.exists(f -> f.name == '__shouldUpdate')) {
          Context.error(
            'Cannot use @lazy and a custom __shouldUpdate method',
            fields.find(f -> f.name == '__shouldUpdate').pos
          );
        }

        var checks:Array<Expr> = [ for (prop in updateProps) {
          var name = prop.name;
          macro if ($i{PROPS}.$name != $i{INCOMING_PROPS}.$name) return true;
        } ];

        builder.add((macro class {
          override function __shouldUpdate($INCOMING_PROPS:Dynamic):Bool {
            $b{checks};
            return false;
          }
        }).fields);
      } 
    });

    builder.addFieldMetaHandler({
      name: 'prop',
      hook: Normal,
      options: [],
      build: function (_, builder, f) switch f.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @prop vars', f.pos);
          }

          var name = f.name;
          var getName = 'get_${name}';
          var init = e == null
            ? macro $i{INCOMING_PROPS}.$name
            : macro $i{INCOMING_PROPS}.$name == null ? @:pos(e.pos) ${e} : $i{INCOMING_PROPS}.$name;
          
          f.kind = FProp('get', 'never', t, null);

          builder.add((macro class {

            inline function $getName() return $i{PROPS}.$name;

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

    builder.addFieldMetaHandler({
      name: 'use',
      hook: Normal,
      options: [],
      build: function (options:{}, builder, field) switch field.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @use vars', field.pos);
          }

          if (e != null) {
            Context.error('@use vars cannot be initialized', field.pos);
          }

          if (!Context.unify(t.toType(), Context.getType('blok.State'))) {
            Context.error('@use must be a blok.State', field.pos);
          }

          var clsName = t.toType().toString();
          if (clsName.indexOf('<') >= 0) clsName = clsName.substring(0, clsName.indexOf('<'));
          
          var path = clsName.split('.'); // is there a better way
          var name = field.name;
          var getter = 'get_$name';
          var backingName = '__computedValue_$name';

          field.kind = FProp('get', 'never', t, null);

          builder.add((macro class {
            var $backingName:$t = null;

            function $getter() {
              if (this.$backingName == null) 
                this.$backingName = $p{path}.from(__context);
              return this.$backingName;
            } 
          }).fields);

          updates.push(macro this.$backingName = null);
        default:
          Context.error('@use can only be used on vars', field.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'observable',
      hook: Normal,
      options: [ { name: 'watch', optional: true } ],
      build: function (options:{ ?watch:Bool }, builder, field) switch field.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @observable vars', field.pos);
          }

          if (e == null ) {
            Context.error('An initializer is required for @observables', field.pos);
          }

          var name = field.name;
          var obsType = macro:blok.core.Observable<$t>;
          var init = e == null
            ? macro $i{INCOMING_PROPS}.$name
            : macro $i{INCOMING_PROPS}.$name == null ? ${e} : $i{INCOMING_PROPS}.$name;

          if (!field.access.contains(AFinal)) {
            field.access.push(AFinal);
          }

          addProp(name, t, e != null);
          field.kind = FVar(obsType, null);
          initHooks.push(macro this.$name = new blok.core.Observable($init));
          disposeHooks.push(macro this.$name.dispose());
          
          // @todo: I'm unsure if we SHOULD notify the observable
          //        here or not. Requires testing.
          updates.push(macro if (Reflect.hasField($i{INCOMING_PROPS}, $v{name})) {
            @:privateAccess this.$name.value = Reflect.field($i{INCOMING_PROPS}, $v{name});
          });

          if (options.watch == true) {
            var observerName = '__observer_$name';
            builder.add((macro class {
              var $observerName:blok.core.Observable.Observer<$t>;
            }).fields);
            initHooks.push(macro this.$observerName = this.$name.observe(_ -> __requestUpdate()));
            disposeHooks.push(macro {
              this.$observerName.cancel();
              this.$observerName = null;
            });
          }
        default: 
          Context.error('@observable can only be used on vars', field.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'update',
      hook: After,
      options: [],
      build: function (options:{ ?silent:Bool }, builder, field) switch field.kind {
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
                __requestUpdate();
              case UpdateState(data): 
                __updateProps(data);
                __requestUpdate();
              case UpdateStateSilent(data):
                __updateProps(data);
            }
          }
        default:
          Context.error('@update must be used on a method', field.pos);
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
      name: 'dispose',
      hook: After,
      options: [],
      build: function (_, builder, field) switch field.kind {
        case FFun(func):
          if (func.args.length > 0) {
            Context.error('@dispose methods cannot have any arguments', field.pos);
          }
          var name = field.name;
          disposeHooks.push(macro @:pos(field.pos) inline this.$name());
        default:
          Context.error('@dispose must be used on a method', field.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'effect',
      hook: After,
      options: [],
      build: function (_, builder, field) switch field.kind {
        case FFun(func):
          if (func.args.length > 0) {
            Context.error('@effect methods cannot have any arguments', field.pos);
          }
          var name = field.name;
          effectHooks.push(macro @:pos(field.pos) inline this.$name());
        default:
          Context.error('@effect must be used on a method', field.pos);
      }
    });

    builder.addFields(() -> {
      var propType = TAnonymous(props);
      var nodeType = nodeTypeName == 'Dynamic' ? macro:Dynamic : Context.getType(nodeTypeName).toComplexType();
      var createParams = cls.params.length > 0
        ? [ for (p in cls.params) { name: p.name, constraints: BuilderHelpers.extractTypeParams(p) } ]
        : [];
      var effects = effectHooks.length > 0 
        ? macro __context.addEffect(() -> $b{effectHooks})
        : macro null; 
      
      return [
        
        {
          name: '__create',
          pos: (macro null).pos,
          access: [ APublic, AStatic ],
          meta: [
            { name: ':noCompletion', pos: (macro null).pos }
          ],
          kind: FFun({
            params: createParams,
            args: [
              { name: 'props', type: macro:$propType },
              { name: 'context', type: macro:blok.core.Context<$nodeType> },
              { name: 'parent', type: macro:blok.core.Component<$nodeType> }
            ],
            expr: macro @:pos(cls.pos) {
              var comp = new $clsTp(props, context, parent);
              comp.__inserted = true;
              return comp;
            },
            ret: macro:blok.core.Component<$nodeType>
          })
        },
        
        {
          name: 'node',
          access: [ AStatic, APublic, AInline ],
          pos: (macro null).pos,
          meta: [],
          kind: FFun({
            params: createParams,
            args: [
              { name: 'props', type: macro:$propType },
              { name: 'key', type: macro:Null<blok.core.Key>, opt: true }
            ],
            expr: macro @:pos(cls.pos) return blok.core.VNode.VComponent(
              $p{ cls.pack.concat([ cls.name ]) },
              props,
              key
            ),
            ret: macro:blok.core.VNode<$nodeType>
          })
        }

      ].concat((macro class {
        var $PROPS:$propType;

        public function new($INCOMING_PROPS:$propType, __context, __parent) {
          this.__parent = __parent;
          this.$PROPS = ${ {
            expr: EObjectDecl(initializers),
            pos: (macro null).pos
          } };
          __registerContext(__context);
          $b{initHooks}
          __render();
        }

        @:noCompletion
        override function __updateProps($INCOMING_PROPS:Dynamic) {
          $b{updates};
        }

        @:noCompletion
        override function __registerEffects() {
          ${effects};
        }

        @:noCompletion
        override function __dispose() {
          $b{disposeHooks};
          super.__dispose();
        }

      }).fields);
    });

    return builder.export();
  }
}
