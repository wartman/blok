package blok.style;

import blok.internal.Style;
import blok.internal.VStyle;

class BaseStyle extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Style.global(Style.raw('
        body, html {
          padding: 0;
          margin: 0;
        }
        
        html {
          box-sizing: border-box;
        }
        
        *, *:before, *:after {
          box-sizing: inherit;
        }
        
        ul, ol, li {
          margin: 0;
          padding: 0;
        }
        
        ul, ol {
          list-style: none;
        }
      '))
    ];
  }
}
