package blok.style;

import blok.core.VStyle;

class BaseStyle {

  public static final id = '__blok_base';

  public static function get():VStyleDecl {
    // todo: add the rest of the base stylesheet
    return VGlobal([
      VRaw('
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
      ')
    ]);
  }

}
