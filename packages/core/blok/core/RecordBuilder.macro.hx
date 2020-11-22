package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;
import blok.core.BuilderHelpers.*;

using haxe.macro.Tools;

class RecordBuilder {
  public static function build() {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var builder = new ClassBuilder(cls, fields);
    var props:Array<Field> = [];
    var withProps:Array<Field> = [];
    var initializers:Array<Expr> = [];
    var toStringProps:Array<Expr> = [];
    var equalsComp:Array<Expr> = [];
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

    function addToString(name:String) {
      toStringProps.push(macro $v{name} + ': ' + Std.string(this.$name));
    }

    function isEqual(name:String) {
      equalsComp.push(macro if (this.$name != other.$name) return false);
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
          addToString(name);
          isEqual(name);
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
          addToString(name);
          isEqual(name);
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
      var clsType = Context.getLocalType().toComplexType();
      return (macro class {
        public function new($INCOMING_PROPS:$propType) {
          $b{initializers};
        }

        /**
          Create a copy of the current record, changing the given
          properties.
        **/
        public function with($INCOMING_PROPS:$withPropType) {
          return new $clsTp(${ {
            expr: EObjectDecl(withBuilder),
            pos: (macro null).pos
          } });
        }

        /**
          Create a copy of the current Record.
        **/
        inline public function copy() {
          return with({});
        }

        /**
          Check if all the fields of this Record match the other Record.
        **/
        public function equals(other:$clsType) {
          $b{equalsComp};
          return true;
        }

        public function toString() {
          return $v{cls.pack.concat([ cls.name ]).join('.')}
            + ' { ' + [ $a{toStringProps} ].join(', ') + ' }';
        }
      }).fields;
    });

    return builder.export();
  }
}