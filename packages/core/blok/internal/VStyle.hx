package blok.internal;

import blok.internal.StyleType;

enum VStyle {
  VStyleDef<Props:{}>(type:StyleType<Props>, ?props:Props, ?suffix:String);
  VStyleList(styles:Array<VStyle>);
}

enum VStyleExpr {
  ENone;
  EProperty(name:String, value:Value, ?important:Bool);
  EChild(style:VStyle);
  EChildren(exprs:Array<VStyleExpr>);
  EWrapped(wrapper:VStyleWrapper, expr:VStyleExpr);
  ERaw(style:String);
}

enum VStyleWrapper {
  WGlobal;
  WCustom(value:String);
  WModifier(modifier:String);
}

enum ValueDef {
  ValueKeyed(key:String, value:Value);
  ValueSingle(value:String);
  ValueCompound(values:Array<Value>);
  ValueList(values:Array<Value>);
  ValueCall(name:String, value:Value);
}

abstract Value(ValueDef) to ValueDef from ValueDef {
  public inline static function compound(values:Array<Value>) {
    return new Value(ValueCompound(values));
  }

  public inline static function list(values:Array<Value>) {
    return new Value(ValueList(values));
  }

  public inline static function call(name:String, value:Value) {
    return new Value(ValueCall(name, value));
  }

  public inline static function keyed(key:String, value:Value) {
    return new Value(ValueKeyed(key, value));
  }
  
  @:from public inline static function ofString(value:String) {
    return new Value(ValueSingle(value));
  }

  @:from public inline static function ofInt(value:Int) {
    return new Value(ValueSingle(Std.string(value)));
  }

  @:from public inline static function ofFloat(value:Float) {
    return new Value(ValueSingle(Std.string(value)));
  }

  @:from public inline static function ofUnit(unit:Unit) {
    return new Value(ValueSingle(unit.toString()));
  }

  public inline function new(value:ValueDef) {
    this = value;
  }

  public inline function unwrap():ValueDef {
    return this;
  }

  public inline function withKey(key:String) {
    return Value.keyed(key, this);
  }

  public function forIdentifier():String {
    return switch unwrap() {
      case ValueKeyed(key, _): 
        key;
      case ValueSingle(value): 
        value;
      case ValueCompound(values) | ValueList(values): 
        values.map(v -> v.forIdentifier()).join('-');
      case ValueCall(_, value): 
        value.forIdentifier();
    }
  }

  @:to public function toString():String {
    return switch unwrap() {
      case ValueKeyed(_, value):
        value.toString();
      case ValueSingle(value): 
        value;
      case ValueCompound(values): 
        values.map(v -> v.toString()).join(' ');
      case ValueList(values): 
        values.map(v -> v.toString()).join(',');
      case ValueCall(name, value):
        return '${name}(${value.toString()})';
    }
  }
}

@:using(blok.internal.VStyle.UnitTools)
enum Unit {
  None;
  Auto;
  Num(value:Int);
  Px(value:Int);
  Pct(value:Int);
  Em(value:Int);
  Rem(value:Int);
  Vh(value:Int);
  Vw(value:Int);
  VMin(value:Int);
  VMax(value:Int);
  Deg(value:Int);
  Sec(value:Int);
  Ms(value:Int);
  Fr(value:Int);
}

class UnitTools {
  
  public static function toString(unit:Unit) {
    if (unit == null) return null;
    return switch unit {
      case None: '0';
      case Auto: 'auto';
      case Num(value): Std.string(value);
      case Px(value): '${value}px';
      case Pct(value): '${value}%';
      case Em(value): '${value}em';
      case Rem(value): '${value}rem';
      case Vh(value): '${value}vh';
      case Vw(value): '${value}vw';
      case VMin(value): '${value}vmin';
      case VMax(value): '${value}vmax';
      case Deg(value): '${value}deg';
      case Sec(value): '${value}s';
      case Ms(value): '${value}ms';
      case Fr(value): '${value}fr';
    }
  }

}
