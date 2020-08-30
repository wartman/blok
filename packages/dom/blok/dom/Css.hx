package blok.dom;

class Css {
  public static macro function define(e) {
    return blok.dom.CssBuilder.define(e);
  }

  public static macro function export(e) {
    return blok.dom.CssBuilder.export(e);
  }
}
