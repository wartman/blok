package blok.internal;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;

using Lambda;

enum ClassBuilderHook {
  Init;
  Normal;
  After;
}

typedef ClassBuilderOption = {
  name:String,
  optional:Bool,
  ?handleValue:(expr:Expr)->Expr
} 

typedef FieldHandler<Options> = {
  public var name:String;
  public var hook:ClassBuilderHook;
  public var options:Array<ClassBuilderOption>;
  public function build(options:Options, builder:ClassBuilder, f:Field):Void;
}

typedef AddFieldHandler = {
  public var hook:ClassBuilderHook;
  public function build():Array<Field>;
} 

class ClassBuilder {
  var fields:Array<Field>;
  var ran:Bool = false;
  final cls:ClassType;
  final fieldHandlers:Array<FieldHandler<Dynamic>> = [];
  final fieldsToAdd:Array<AddFieldHandler> = [];

  public function new(cls, fields) {
    this.cls = cls;
    this.fields = fields;
  }

  public function addFieldHandler<Options>(handler:FieldHandler<Options>) {
    fieldHandlers.push(handler);
  }

  public function addFields(build:() -> Array<Field>, hook:ClassBuilderHook = After) {
    fieldsToAdd.push({
      build: build,
      hook: hook
    });
  }

  public function add(fields:Array<Field>) {
    this.fields = this.fields.concat(fields);
  }

  public function export() {
    if (!ran) run();
    return fields;
  }

  public function run() {
    if (ran) return;
    ran = true;

    function parseFieldMetaHook(hook:ClassBuilderHook) {
      var copy = fields.copy();
      var fb = fieldHandlers.filter(h -> h.hook == hook);
      if (fb.length > 0) for (f in copy) parseFieldMeta(f, fb);
      var toAdd = fieldsToAdd.filter(f -> f.hook == hook);
      if (toAdd.length > 0) for (handler in toAdd) add(handler.build());
    }
    
    parseFieldMetaHook(Init);
    parseFieldMetaHook(Normal);
    parseFieldMetaHook(After);
  }

  function parseFieldMeta(field:Field, fieldBuilders:Array<FieldHandler<Dynamic>>) {
    if (field.meta == null) return;

    var toRemove:Array<MetadataEntry> = [];

    for (handler in fieldHandlers) {
      var match = (m:MetadataEntry) -> m.name == handler.name; 
      if (field.meta.exists(match)) {
        function handle(meta:MetadataEntry) {
          var options = parseOptions(meta.params, handler.options, meta.pos);
          handler.build(options, this, field);
          toRemove.push(meta);
        }

        switch field.meta.filter(match) {
          case [ m ]: handle(m);
          case many: 
            // if (handler.multiple) {
            //   for (m in many) handle(m);
            // } else {
              Context.error('Only one @${handler.name} is allowed', many[1].pos);
            // }
        }
      }
    }

    if (toRemove.length > 0) for (entry in toRemove) field.meta.remove(entry);
  }

  function parseOptions(
    params:Null<Array<Expr>>,
    def:Array<ClassBuilderOption>,
    pos:Position
  ):{} {
    var options:{} = {};

    if (params == null) return options;

    function addOption(name:String, value:Expr, pos:Position) {
      var info = def.find(o -> o.name == name);
      if (info == null) {
        Context.error('The option [ ${name} ] is not allowed here', pos);
      }
      if (Reflect.hasField(options, name)) {
        Context.error('The option ${name} was defined twice', pos);
      }
      Reflect.setField(options, name, info.handleValue != null
        ? info.handleValue(value)
        : parseConst(value)
      );
    }

    for (p in params) switch p {
      case macro ${ { expr:EConst(CIdent(s)), pos: _ } } = ${e}:
        addOption(s, e, p.pos);
      case macro ${ { expr:EConst(CIdent(s)), pos: _ } }:
        addOption(s, macro true, p.pos);
      default:
        Context.error('Invalid expression', p.pos);
    }

    for (o in def) {
      if (!Reflect.hasField(options, o.name)) {
        if (!o.optional) {
          Context.error('Missing required option ${o.name}', pos);
        }
      }
    }

    return options;
  }

  function parseConst(expr:Expr):Dynamic {
    return switch expr.expr {
      case EConst(c): switch c {
        case CIdent('false'): false;
        case CIdent('true'): true;
        case CString(s, _) | CIdent(s): s;
        case CInt(v): v;
        case CFloat(f): f;
        case CRegexp(_, _):
          Context.error('Regular expressions are not allowed here', expr.pos);
          null;
      }
      default: 
        Context.error('Values must be constant', expr.pos);
        null;
    }
  }
}
