package blok.util;

class Body {
  static inline function getBody() {
    return js.Browser.document.body;
  }

  public static inline function lock() {
    var body = getBody();
    var beforeWidth = body.offsetWidth;
    body.setAttribute('style', 'overflow:hidden;');
    var afterWidth = body.offsetWidth;
    var offset = afterWidth - beforeWidth;
    if (offset > 0) {
      body.setAttribute('style', 'overflow:hidden;padding-right:${offset}px');
    }
  }

  public static inline function unlock() {
    getBody().removeAttribute('style');
  }
}
