package blok.dom;

import js.html.Node;
import blok.core.Key;
import blok.core.VNode;
import blok.core.StyleList;

typedef HtmlBaseProps<Attrs:{}> = {
  ?ref:(node:Node)->Void,
  ?style:StyleList,
  ?key:Key,
  ?attrs:Attrs
}

typedef HtmlChildrenProps<Attrs:{}> = HtmlBaseProps<Attrs> & {
  ?children:Children
}

@:build(blok.dom.HtmlBuilder.build())
class Html {
  public static inline function fragment(children:Children) {
    return VFragment(children);
  }

  public static inline function text(content:String, ?key:Key) {
    return VNative(TextType, { content: content }, null, null, key, []);
  }
}
