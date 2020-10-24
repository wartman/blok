package blok.statik;

import blok.Node;
import blok.core.Plugin;
import blok.core.PluginProvider;
import blok.html.HtmlAttributes;
import blok.style.VStyle;
import blok.style.StyleList;
import blok.style.Style;

using Lambda;
using blok.html.CssGenerator;

typedef StylePluginOptions = {} 

class StylePlugin implements Plugin<Node> {
  public static final defined:Array<String> = [];
  public static final output:Map<String, String> = [];

  public static function provide(?options, build):VNode {
    return PluginProvider.provide(() -> new StylePlugin(options), build);
  }

  public function new(options:StylePluginOptions) {
    
  }

  public function onCreate(content:Context, vnode:VNode):Void {
    handleStyles(vnode);
  }

  public function onUpdate(content:Context, vnode:VNode):Void {
    handleStyles(vnode);
  }

  function handleStyles(vnode:VNode) {
    switch vnode {
      case VNative(type, props, plugables, _, _, _) if (plugables != null): 
        switch Std.downcast(type, NodeType) {
          case null:
          case _:
            var attrs:GlobalAttr = cast props;
            var styles:StyleList = plugables
              .filter(p -> 
                p.key == Style.pluginKey 
                && !p.handled
                && p.value != null
              ).flatMap(p -> {
                p.handled = true; // Make sure this won't be reused.
                p.value;
              })
              .filter(p -> p != null);

            if (styles.length == 0) return;

            var classNames = processClasses(styles);
        }
      default:
    }
  }

  function processClasses(style:StyleList) {
    var classNames:Array<String> = [];

    function addCss(name:String, s:VStyle) {
      var result = s.generate();
      classNames = classNames.concat(result.classes);
      output.set(name, result.rules.join('\n'));
    }

    for (s in style) switch s {
      case VStyleDef(type, props, suffix):
        var name = type.getStyleName(props, suffix);
        if (defined.contains(name)) {
          classNames.push(name.getUniqueClassName());
        } else {
          defined.push(name);
          addCss(name, s);
        }
      case VStyleInline(name, def):
        if (defined.contains(name)) {
          classNames.push(name.getUniqueClassName());
        } else {
          defined.push(name);
          addCss(name, s);
        }
      case VStyleList(styles):
        classNames = classNames.concat(processClasses(styles));
    }

    return classNames;
  }
}
