package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;
import blok.core.BuilderHelpers.*;

class PureObjectBuilder {
  public static function build() {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var builder = new ClassBuilder(cls, fields);
    var props:Array<Field> = [];
    var withProps:Array<Field> = [];
    var initializers:Array<Expr> = [];
    var withBuilder:Array<ObjectField> = [];

    function addProp(name:String, type:ComplexType, isOptional:Bool, isUpdateable:Bool) {
      props.push({
        name: name,
        kind: FVar(type, null),
        access: [ APublic ],
        meta: isOptional ? [ OPTIONAL_META ] : [],
        pos: (macro null).pos
      });
      if (isUpdateable) withProps.push({
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
      build: function (options:{}, builder, field) switch field.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @prop vars', field.pos);
          }

          if (!field.access.contains(APublic)) {
            field.access.remove(APrivate);
            field.access.push(APublic);
          }

          if (!field.access.contains(AFinal)) {
            field.access.push(AFinal);
          }

          var name = field.name;

          addProp(field.name, t, e != null, true);
          initializers.push(e == null
            ? macro this.$name = $i{INCOMING_PROPS}.$name
            : macro this.$name = $i{INCOMING_PROPS}.$name == null ? ${e} : $i{INCOMING_PROPS}.$name 
          );
          withBuilder.push({
            field: name,
            expr: macro $i{INCOMING_PROPS}.$name == null ? this.$name : $i{INCOMING_PROPS}.$name 
          });
        default:
          Context.error('@prop can only be used on vars', field.pos);
      }
    });

    builder.addFieldMetaHandler({
      name: 'constant',
      hook: Normal,
      options: [],
      build: function (options:{}, builder, field) switch field.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @constant vars', field.pos);
          }

          if (!field.access.contains(APublic)) {
            field.access.remove(APrivate);
            field.access.push(APublic);
          }

          if (!field.access.contains(AFinal)) {
            field.access.push(AFinal);
          }

          var name = field.name;

          addProp(field.name, t, e != null, false);
          initializers.push(e == null
            ? macro this.$name = $i{INCOMING_PROPS}.$name
            : macro this.$name = $i{INCOMING_PROPS}.$name == null ? ${e} : $i{INCOMING_PROPS}.$name 
          );
          withBuilder.push({
            field: name,
            expr: macro this.$name
          });
        default:
          Context.error('@constant can only be used on vars', field.pos);
      }
    });

    builder.addFields(() -> {
      var propType = TAnonymous(props);
      var withPropType = TAnonymous(withProps);
      return (macro class {
        public function new($INCOMING_PROPS:$propType) {
          $b{initializers};
        }

        @:pure
        public function with($INCOMING_PROPS:$withPropType) {
          return new $clsTp(${ {
            expr: EObjectDecl(withBuilder),
            pos: (macro null).pos
          } });
        }
      }).fields;
    });

    return builder.export();
  }
}