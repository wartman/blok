package blok.core.html;

#if !blok.core.style
  #error "Cannot use blok.core.html.CssValue without blok.core.style"
#end

enum CssValueDef {
  CssValueSingle(value:Dynamic);
  CssValueCompound(values:Array<CssValue>);
  CssValueList(values:Array<CssValue>);
  CssValueCall(name:String, value:CssValue);
}

abstract CssValue(CssValueDef) to CssValueDef from CssValueDef {
  public inline static function compound(values:Array<CssValue>) {
    return new CssValue(CssValueCompound(values));
  }

  public inline static function list(values:Array<CssValue>) {
    return new CssValue(CssValueList(values));
  }

  public inline static function call(name:String, value:CssValue) {
    return new CssValue(CssValueCall(name, value));
  }
  
  @:from public inline static function ofString(value:String) {
    return new CssValue(CssValueSingle(value));
  }

  @:from public inline static function ofInt(value:Int) {
    return new CssValue(CssValueSingle(value));
  }

  @:from public inline static function ofFloat(value:Float) {
    return new CssValue(CssValueSingle(value));
  }

  @:from public inline static function ofCssUnit(unit:CssUnit) {
    return new CssValue(CssValueSingle(switch unit {
      case None: 0;
      case Num(value): value;
      default: unit.toString();
    }));
  }

  public inline function new(value:CssValueDef) {
    this = value;
  }

  public inline function unwrap():CssValueDef {
    return this;
  }

  @:to public function toString():String {
    return switch unwrap() {
      case null: '';
      case CssValueSingle(value):
        value == null ? null : Std.string(value);
      case CssValueCompound(values): 
        values.map(v -> v.toString())
          .filter(v -> v != null)
          .join(' ');
      case CssValueList(values): 
        values.map(v -> v.toString())
          .filter(v -> v != null)
          .join(',');
      case CssValueCall(name, value):
        return '${name}(${value.toString()})';
    }
  }
}