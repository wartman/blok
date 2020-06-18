package blok.core;

using StringTools;

// @todo: cleanup and extract the rendering stuff from here?

@:using(blok.core.VStyle.VStyleDeclTools)
enum VStyleDecl {
  VCustomStyle<Attrs:{}>(type:StyleType<Attrs>, attrs:Attrs, ?customSuffix:String);
  VGlobal(props:Array<VStyle>);
  // Todo: allow this or force everything to use VCustomStyle?
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

  public static function render(style:VStyleDecl):String {
    return switch style {
      case VCustomStyle(type, attrs, suffix):
        type.__render(attrs, suffix);

      case VGlobal(props):
        renderProps(null, props);

      case VClass(_, props):
        renderProps(style.getSelector(), props);
    }
  }

  static function renderProps(selector:String, styles:Array<VStyle>):String {
    var out = [];
    var def:Array<String> = [];

    function applySelector(suffix:String) {
      return selector != null
        ? selector + suffix
        : suffix;
    }

    function process(styles:Array<VStyle>) {
      for (s in styles) if (s != null) switch s {
        case VNone | null:

        case VRaw(value):
          if (selector != null)
            out.push('${selector} { ${value} }');
          else
            out.push(value);

        case VGlobal(styles):
          out.push(renderProps(null, styles));  
        
        case VProperty(name, value, important):
          if (important == true)
            def.push('${name}: ${renderValue(value)} !important;');
          else
            def.push('${name}: ${renderValue(value)};');

        case VChild(name, styles):
          out.push(renderProps(applySelector(' ${name}'), styles));

        case VChildren(styles):
          process(styles);
        
        case VPsuedo(type, styles):
          out.push(renderProps(applySelector(type), styles));

        case VMedia(mediaSelector, styles):
          out.push('@media ${mediaSelector} { ${renderProps(selector, styles)}  }');
      }
    }

    process(styles);

    if (def.length > 0) {
      if (selector == null) {
       #if debug
          throw 'Properties must be inside a selector';
        #else
          return out.join(' ');
        #end
      }
      out.unshift('${selector} { ${def.join(' ')} }');
    }

    return out.join(' ');
  }

  static function renderValue(value:Value):String {
    return switch value {
      case KeyedValue(_, value):
        renderValue(value);
      case SingleValue(v): 
        v;
      case CompoundValue(values): 
        values.map(renderValue).join(' ');
      case ListValue(values): 
        values.map(renderValue).join(',');
      case CallValue(name, value):
        return '${name}(${renderValue(value)})';
    }
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

@:using(blok.core.VStyle.ValueTools)
enum Value {
  KeyedValue(key:String, value:Value);
  SingleValue(value:ValueDef);
  CompoundValue(values:Array<Value>);
  ListValue(values:Array<Value>);
  CallValue(name:String, value:Value);
}

class ValueTools {

  public static function forClassName(value:Value):String {
    return switch value {
      case KeyedValue(key, _): key;
      case SingleValue(value): value;
      case CompoundValue(values) | ListValue(values): return [
        for (value in values) value.forClassName()
      ].join('-');
      case CallValue(_, value): value.forClassName();
    }
  }

}

abstract ValueDef(String) from String to String {
  
  @:from public inline static function ofUnit(unit:Unit):ValueDef {
    return unit.toString();
  }

  @:from public inline static function ofUnitArray(units:Array<Unit>):ValueDef {
    return units.map(u -> u.toString()).join(' ');
  }

  @:from public inline static function ofInt(int:Int):ValueDef {
    return Std.string(int);
  }

  @:from public inline static function ofFloat(f:Float):ValueDef {
    return Std.string(f);
  }

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
