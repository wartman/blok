package blok.html;

#if !blok.core.style
  #error "Cannot use blok.html.Css without blok.core.style"
#end

class Css {
  public static macro function define(e) {
    return blok.html.CssBuilder.define(e);
  }

  public static macro function export(e) {
    return blok.html.CssBuilder.export(e);
  }
}
