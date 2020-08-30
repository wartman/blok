package blok.core;

import haxe.macro.Expr;
import haxe.macro.Context;

using Lambda;
using haxe.macro.PositionTools;
using haxe.macro.Tools;

class Style {
  /**
    A handy macro to define a style inline in a component. Note that
    styles created in this way cannot use local variables and will not
    change when the Component is updated.

    @todo: Make the explaination up there a bit better. A name like "defineStatic"
           might be a bit more self-documenting?

    @todo: This currently breaks code-completion and is a bit weird to use.
  **/
  public static function define(e:ExprOf<Array<blok.core.VStyle.VStyleExpr>>) {
    var min = e.pos.getInfos().min;
    var typeName = Context.getLocalType().toString();
    var pack = typeName.split('.');
    var name = pack.pop();
    var tp:TypePath = {
      pack: pack,
      name: '${name}_Style${min}'
    };
    var cls = macro class {
      override function render():Array<blok.core.VStyle.VStyleExpr> @:pos(e.pos) return $e;
    };
    var module = tp.pack.concat([ tp.name ]).join('.');
    var localUsings = Context.getLocalUsing();
    var usings:Array<TypePath> = [];

    for (lu in localUsings) {
      var t = lu.get();
      var mod = t.module.split('.');
      var name = mod.pop();
      var tp:TypePath = {
        pack: mod,
        name: name
      };
      if (!usings.exists(u -> u.pack == tp.pack && u.name == tp.name)) {
        usings.push(tp);
      }
    }

    Context.defineModule(module, [
      {
        pack: tp.pack,
        name: tp.name,
        pos: (macro null).pos,
        params: [],
        kind: TDClass({
          pack: [ 'blok', 'core' ],
          name: 'Style'
        }, null, false, true),
        fields: cls.fields
      }
    ], Context.getLocalImports(), usings);

    return macro blok.core.VStyle.VStyleDef($p{tp.pack.concat([ tp.name ])}, {});
  }
  
}
