package blok.core.style;

import haxe.macro.Context;
import haxe.macro.Expr;
import blok.core.ClassBuilder;

using haxe.macro.Tools;

class StyleBuilder {
  static final PROPS = '__props';
  static final SUFFIX = '__suffix';
  static final INCOMING_PROPS = '__incomingProps';

  public static function build() {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsName = cls.pack.concat([ cls.name ]).join('.');
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var props:Array<Field> = [];
    var nameBuilder:Array<Expr> = [];
    var initializers:Array<ObjectField> = [];
    var builder = new ClassBuilder(cls, fields);

    function addProp(name:String, type:ComplexType, isOptional:Bool, skip = false) {
      props.push({
        name: name,
        kind: FVar(type, null),
        access: [ APublic ],
        meta: isOptional ? [ { name: ':optional', pos: (macro null).pos } ] : [],
        pos: (macro null).pos
      });
      if (skip != true) {
        nameBuilder.push(macro $v{name} + ': ' + Std.string($i{PROPS}.$name));
      }
    }

    builder.addFieldMetaHandler({
      name: 'prop',
      hook: Normal,
      options: [
        { name: 'dontUseInName', optional: true }
      ],
      build: function (options:{ ?dontUseInName:Bool }, builder, f) switch f.kind {
        case FVar(t, e):
          if (t == null) {
            Context.error('Types cannot be inferred for @prop vars', f.pos);
          }

          var name = f.name;
          var getName = 'get_${name}';
          var init = e == null
            ? macro $i{INCOMING_PROPS}.$name
            : macro $i{INCOMING_PROPS}.$name == null ? ${e} : $i{INCOMING_PROPS}.$name;
          
          addProp(name, t, e != null, options.dontUseInName);
          initializers.push({
            field: name,
            expr: init
          });

          f.kind = FProp('get', 'never', t, null);

          builder.add((macro class {
            function $getName() return $i{PROPS}.$name;
          }).fields);
        default:
          Context.error('@prop can only be used on vars', f.pos);
      }
    });

    builder.addFields(() -> {
      var propType = TAnonymous(props);
      var name = macro $v{clsName} + ' { ' + [ $a{nameBuilder} ].join(', ') + ' }';

      if (props.length == 0) {
        builder.add((macro class {
          static final __inst = new $clsTp({});
        }).fields);
      }

      return [
        {
          name: 'style',
          access: [ AStatic, APublic, AInline ],
          pos: cls.pos,
          meta: [],
          kind: FFun({
            ret: macro:blok.core.style.VStyle,
            params: cls.params.length > 0
              ? [ for (p in cls.params) { name: p.name, constraints: [] } ]
              : [],
            args: switch props.length {
              case 0: [];
              default: [ { name: 'props', type: macro:$propType } ];
            },
            expr: switch props.length {
              case 0: macro return VStyleDef($p{cls.pack.concat([ cls.name ])}, {});
              default: macro return VStyleDef($p{cls.pack.concat([ cls.name ])}, props);
            }
          })
        },

        {
          name: 'export',
          access: [ AStatic, APublic ],
          pos: cls.pos,
          meta: [],
          kind: FFun({
            ret: macro:blok.core.style.StyleExpr,
            params: cls.params.length > 0
              ? [ for (p in cls.params) { name: p.name, constraints: [] } ]
              : [],
            args: switch props.length {
              case 0: [];
              default: [ { name: 'props', type: macro:$propType } ];
            },
            expr: macro {
              var style = ${ switch props.length { 
                case 0: macro new $clsTp({});
                default: macro new $clsTp(props);
              } }
              return style.render();
            }
          })
        },

        {
          name: 'renderStyle',
          access: [ AStatic, APublic, AInline ],
          pos: cls.pos,
          meta: [],
          kind: FFun({
            ret: macro:blok.core.style.StyleExpr,
            params: cls.params.length > 0
              ? [ for (p in cls.params) { name: p.name, constraints: [] } ]
              : [],
            args: [ { name: 'props', type: macro:$propType } ],
            expr: switch props.length {
              case 0: macro return __inst.render();
              default: macro return new $clsTp(props).render();
            } 
          })
        }
      ].concat((macro class {
        var $PROPS:$propType;

        public static function getStyleId($PROPS:$propType):String {
          return ${name};
        }

        override function getId():String {
          return getStyleId(this.$PROPS);
        }

        public function new($INCOMING_PROPS:$propType) {
          this.$PROPS = ${ {
            expr: EObjectDecl(initializers),
            pos: (macro null).pos
          } };
        }
      }).fields);
    }, After);

    return builder.export();
  }
}
