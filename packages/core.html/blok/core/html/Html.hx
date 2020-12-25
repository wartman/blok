package blok.core.html;

import blok.Node;
import blok.core.Key;
import blok.core.VNode;

typedef HtmlBaseProps<Attrs:{}> = {
  // `blok.Node` differs depending on if this is `static` or `dom`.
  // A bit of a hack, really; might look into creating a build system
  // like we have with Component and State.
  ?ref:(node:Node)->Void,
  ?key:Key,
  ?attrs:Attrs
}

typedef HtmlChildrenProps<Attrs:{}> = HtmlBaseProps<Attrs> & {
  ?children:Array<VNode<Node>>
}

@:build(blok.core.html.HtmlBuilder.build())
class Html {
  public static inline function fragment(children:Array<VNode<Node>>) {
    return VFragment(children);
  }

  public static inline function text(content:String, ?key:Key) {
    return VNative(TextType, { content: content }, null, key, []);
  }
}
