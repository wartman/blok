package blok.core.foundation.style;

import blok.core.style.StyleExpr;
import blok.core.html.CssUnit;
import blok.core.html.Css;

enum abstract MediaType(String) to String {
  var All = 'all';
  var Print = 'print';
  var Screen = 'screen';
  var Speech = 'speech';
}

typedef MediaQueryOptions = {
  @:optional public final type:MediaType;
  @:optional public final maxWidth:CssUnit;
  @:optional public final minWidth:CssUnit;
  public final rules:Array<StyleExpr>;
} 

/**
  Define a media query.
**/
class MediaQuery {
  public static function raw(condition:String, exprs:Array<StyleExpr>) {
    return Css.wrap('@media ${condition}', exprs);
  }

  public static function export(options:MediaQueryOptions) {
    var selector:Array<String> = [];
    if (options.type != null) 
      selector.push(options.type);
    if (options.maxWidth != null) 
      selector.push('(max-width: ${options.maxWidth.toString()})');
    if (options.minWidth != null) 
      selector.push('(min-width: ${options.minWidth.toString()})');
    return Css.wrap('@media ' + selector.join(' and '), options.rules);
  }

  public inline static function minWidth(width:CssUnit, exprs) {
    return export({ minWidth: width, rules: exprs});
  }

  public inline static function maxWidth(width:CssUnit, exprs) {
    return export({ maxWidth: width, rules: exprs });
  }

  /**
    Define an inline media query.

    Note: Just as with `Style.define`, this style will NOT update
    if values change. Only the initial configuration will
    have an effect. Use with caution.
  **/
  macro public static function define(options) {
    return macro blok.core.style.Style.define(
      @:pos(options.pos) blok.core.foundation.style.MediaQuery.export(${options})
    );
  }
}
