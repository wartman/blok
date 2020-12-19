package blok.core.foundation.style;

import blok.core.style.StyleExpr;
import blok.core.style.Style;
import blok.core.html.Css;
import blok.core.html.CssValue;

enum abstract FontFormat(String) to String {
  var Woff = "woff";
  var Woff2 = "woff2";
  var Truetype = "truetype";
  var Opentype = "opentype";
  var EmbeddedOpentype = "embedded-opentype";
  var Svg = "svg";
}

typedef FontSource = {
  public final src:String;
  public final ?format:FontFormat;
}

class FontFace extends Style {
  @prop var family:String;
  @prop var src:Array<FontSource>;
  @prop var stretch:CssValue = null;
  @prop var weight:Font.FontWeight = null;
  @prop var kind:CssValue = null;
  // todo: font-variant
  // todo: font-feature-settings
  // todo: font-variation-settings

  override function render():StyleExpr {
    var props:Array<StyleExpr> = [
      Css.property('font-family', family),
      Css.property('src', CssValue.list(src.map(source -> if (source.format == null) {
        CssValue.call('src', source.src);
      } else {
        CssValue.compound([
          CssValue.call('src', source.src),
          CssValue.call('format', source.format)
        ]);
      })))
    ];
    
    if (stretch != null) props.push(Css.property('font-stretch', stretch));
    if (weight != null) props.push(Css.property('font-weight', switch weight {
      case Normal: 'normal';
      case Bold: 'bold';
      case Inherit: 'inherit';
      case Initial: 'initial';
      case Unset: 'unset';
      case Custom(value): value;
    }));
    if (kind != null) props.push(Css.property('font-style', kind));
    
    return Css.global([ 
      Css.wrap('@font-face', props) 
    ]);
  }
}
