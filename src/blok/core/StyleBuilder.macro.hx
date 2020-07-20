package blok.core;

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;

// @todo: dry with ComponentBuilder
class StyleBuilder {

  static final PROPS = '__props';
  static final SUFFIX = '__suffix';
  static final INCOMING_PROPS = '__incomingProps';
  
  public static function build() {
    var fields = Context.getBuildFields();
    var cls = Context.getLocalClass().get();
    var clsName = cls.pack.concat([ cls.name ]).join('-');
    var clsTp:TypePath = { pack: cls.pack, name: cls.name };
    var props:Array<Field> = [];
    var nameBuilder:Array<Expr> = [];
    var initializers:Array<ObjectField> = [];

    function addProp(name:String, type:ComplexType, isOptional:Bool) {
      props.push({
        name: name,
        kind: FVar(type, null),
        access: [ APublic ],
        meta: isOptional ? [ { name: ':optional', pos: (macro null).pos } ] : [],
        pos: (macro null).pos
      });
      nameBuilder.push(
        macro $i{PROPS}.$name != null 
          ? ${ Context.unify(type.toType(), Context.getType('blok.core.VStyle.Unit')) 
              ? macro $i{PROPS}.$name.toString()
              : Context.unify(type.toType(), Context.getType('blok.core.VStyle.ValueDef'))
                ? macro $i{PROPS}.$name.forClassName()
                : macro Std.string($i{PROPS}.$name)
            }
          : '_'
      );
    }
    
    var builder = new ClassBuilder(fields, cls);
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

          // todo: ensure that all props can be stringified?

          var name = f.name;
          var getName = 'get_${name}';
          var init = e == null
            ? macro $i{INCOMING_PROPS}.$name
            : macro $i{INCOMING_PROPS}.$name == null ? ${e} : $i{INCOMING_PROPS}.$name;
          
          addProp(name, t, e != null);
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

    builder.run();

    var propType = TAnonymous(props);
    var name = macro $v{clsName} + ($i{SUFFIX} != null ? '--' + $i{SUFFIX} : ${if (nameBuilder.length == 0) 
      macro ''
    else
      macro  '--' + [ $a{nameBuilder} ].join('-')});
    
    builder.add([ 
      
      {
        name: 'style',
        access: [ AStatic, APublic, AInline ],
        pos: cls.pos,
        kind: FFun({
          ret: macro:blok.core.VStyle.VStyleDecl,
          params: cls.params.length > 0
            ? [ for (p in cls.params) { name: p.name, constraints: [] } ]
            : [],
          args: [
            { name: 'props', type: macro:$propType },
            { name: 'suffix', type: macro:Null<String>, opt: true }
          ],
          expr: macro return VCustomStyle($p{cls.pack.concat([ cls.name ])}, props, suffix)
        })
      },

      {
        name: 'export',
        access: [ AStatic, APublic ],
        pos: cls.pos,
        kind: FFun({
          ret: macro:blok.core.VStyle,
          params: cls.params.length > 0
            ? [ for (p in cls.params) { name: p.name, constraints: [] } ]
            : [],
          args: [
            { name: 'props', type: macro:$propType }
          ],
          expr: macro {
            var style = new $clsTp(props);
            return VChildren(style.render());
          }
        })
      },
      
      {
        name: 'select',
        access: [ AStatic, APublic ],
        pos: cls.pos,
        kind: FFun({
          ret: macro:blok.core.VStyle,
          params: cls.params.length > 0
            ? [ for (p in cls.params) { name: p.name, constraints: [] } ]
            : [],
          args: [
            { name: 'name', type: macro:String },
            { name: 'props', type: macro:$propType }
          ],
          expr: macro {
            var style = new $clsTp(props);
            return VChild(name, style.render());
          }
        })
      }

    ]);

    builder.add((macro class {

      var $PROPS:$propType;

      public static function __generateName($PROPS:$propType, $SUFFIX:Null<String>):String {
        return ${name};
      }

      public static function __render($PROPS:$propType, $SUFFIX:Null<String>) {
        var style = new $clsTp($i{PROPS});
        var def:blok.core.VStyle.VStyleDecl = VClass(${name}, style.render());
        return def;
      }

      public function new($INCOMING_PROPS:$propType) {
        this.$PROPS = ${ {
          expr: EObjectDecl(initializers),
          pos: (macro null).pos
        } };
      }

    }).fields);

    return builder.export();
  }

}