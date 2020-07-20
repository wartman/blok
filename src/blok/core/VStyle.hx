package blok.core;

using StringTools;

@:using(blok.core.VStyle.VStyleDeclTools)
enum VStyleDecl {
  VCustomStyle<Attrs:{}>(type:StyleType<Attrs>, attrs:Attrs, ?customSuffix:String);
  VGlobal(props:Array<VStyle>);
  VClass(name:String, styles:Array<VStyle>);
}

class VStyleDeclTools {

  static final sep:String = '-';
  static final specifierSep:String = '--';

  public static function getName(style:VStyleDecl):String {
    return switch style {
      case VCustomStyle(type, attrs, suffix): 
        escapeClassName(type.__generateName(attrs, suffix));
      case VClass(name, _): 
        escapeClassName(name);
      default: null;
    }
  }

  public static function getSelector(style:VStyleDecl) {
    var name = getName(style);
    if (name == null) return null;
    return '.' + name;
  }

  static function escapeClassName(name:String) {
    return name
      .replace('.', '_')
      .replace(' ', '_')
      .replace('#', '_')
      .replace('(', '_')
      .replace(')', '_')
      .replace('%', 'pct');
    // etc
  }

}

enum VStyle {
  VNone;
  VProperty(name:String, value:Value, ?important:Bool);
  VChild(name:String, styles:Array<VStyle>);
  VChildren(styles:Array<VStyle>);
  VPsuedo(type:PsuedoClass, styles:Array<VStyle>);
  VMedia(selector:String, styles:Array<VStyle>);
  VRaw(css:String);
  VGlobal(styles:Array<VStyle>);
}

abstract Value(ValueDef) to ValueDef from ValueDef {

  public inline static function compound(values:Array<Value>) {
    return new Value(CompoundValue(values));
  }

  public inline static function list(values:Array<Value>) {
    return new Value(ListValue(values));
  }

  public inline static function call(name:String, value:Value) {
    return new Value(CallValue(name, value));
  }

  public inline static function keyed(key:String, value:Value) {
    return new Value(KeyedValue(key, value));
  }
  
  @:from public inline static function ofString(value:String) {
    return new Value(SingleValue(value));
  }

  @:from public inline static function ofInt(value:Int) {
    return new Value(SingleValue(Std.string(value)));
  }

  @:from public inline static function ofFloat(value:Float) {
    return new Value(SingleValue(Std.string(value)));
  }

  @:from public inline static function ofUnit(unit:Unit) {
    return new Value(SingleValue(unit.toString()));
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

  public function forClassName():String {
    return switch unwrap() {
      case KeyedValue(key, _): 
        key;
      case SingleValue(value): 
        value;
      case CompoundValue(values) | ListValue(values): 
        values.map(v -> v.forClassName()).join('-');
      case CallValue(_, value): 
        value.forClassName();
    }
  }

  @:to public function toString():String {
    return switch unwrap() {
      case KeyedValue(_, value):
        value.toString();
      case SingleValue(value): 
        value;
      case CompoundValue(values): 
        values.map(v -> v.toString()).join(' ');
      case ListValue(values): 
        values.map(v -> v.toString()).join(',');
      case CallValue(name, value):
        return '${name}(${value.toString()})';
    }
  }

}

enum ValueDef {
  KeyedValue(key:String, value:Value);
  SingleValue(value:String);
  CompoundValue(values:Array<Value>);
  ListValue(values:Array<Value>);
  CallValue(name:String, value:Value);
}

enum abstract PsuedoClass(String) to String {
  var Focus = ':focus';
  var Hover = ':hover';
  var Active = ':active';
  var FirstChild = ':first-child';
  var LastChild = ':last-child';
}

@:using(blok.core.VStyle.UnitTools)
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
