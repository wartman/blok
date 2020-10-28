package blok.statik;

#if !blok.platform.static
  #error "blok.statik.StylePlugin can only be used with the blok.platform.static package";
#end

import blok.core.Plugin;

class StylePlugin implements Plugin<Node> {
  // todo
}
