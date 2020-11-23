package blok.dom;

#if !blok.platform.dom
  #error "blok.dom.CssPlugin can only be used with the blok.platform.dom package";
#end

#if !blok.core.style
  #error "blok.dom.CssPlugin requires the blok.core.style package";
#end

import js.Browser;
import js.html.Node;
import js.html.CSSStyleSheet;
import js.html.StyleElement;
import blok.core.Plugin;
import blok.core.PluginProvider;
import blok.core.html.HtmlAttributes;
import blok.core.html.CssRenderer;
import blok.core.style.VStyle;
import blok.core.style.StylePluginPayload;
import blok.core.style.StyleList;

using Lambda;

typedef CssPluginOptions = {
  /**
    A StyleElement to use instead of the default.
  **/
  @:optional public final el:StyleElement;

  /**
    A prefix that will be applied to all styles handled by
    this plugin. If left blank a simple prefix will be 
    generated.
  **/
  @:optional public final prefix:String;
}

class CssPlugin implements Plugin<Node> {
  static var uid:Int = 0;

  public static function provide(?options, build):VNode {
    return PluginProvider.provide(() -> new CssPlugin(options), build);
  }

  final id:Int;
  final renderer:CssRenderer;
  final sheet:CSSStyleSheet;
  final indices:Map<String, Int> = [];
  final defined:Array<String> = [];

  public function new(?options:CssPluginOptions) {
    if (options == null) options = {};
    var el = options.el != null ? options.el : Browser.document.createStyleElement();
    if (options.el == null) Browser.document.head.appendChild(el);
    
    sheet = cast el.sheet;
    id = uid++;
    renderer = new CssRenderer({
      prefix: options.prefix == null ? '_b' : options.prefix
    });
  }

  public function onCreate(context:Context, vnode:VNode):Void {
    handleStyles(vnode);
  }

  public function onUpdate(context:Context, vnode:VNode):Void {
    handleStyles(vnode);
  }
  
  function handleStyles(vnode:VNode) {
    switch vnode {
      case VNative(type, props, plugables, _, _, _) if (plugables != null): 
        switch Std.downcast(type, NodeType) {
          case null:
          case _:
            var attrs:GlobalAttr = cast props;
            var styles:StyleList = plugables.flatMap(p -> switch Std.downcast(p, StylePluginPayload) {
              case null: [];
              case plugin: plugin.value.filter(item -> item != null);
            });

            if (styles.length == 0) return;
            
            var classNames = processClasses(styles);
            if (attrs.className == null)
              attrs.className = classNames.join(' ');
            else 
              attrs.className += ' ' + classNames.join(' ');
        }
      default:
    }
  }

  function processClasses(style:StyleList) {
    var classNames:Array<String> = [];

    function handleCssRendererResult(result:CssRendererResult) switch result {
      case None:
      case Definition(className, rules):
        classNames.push(className);
        insertRule(className, rules);
      case Multiple(results):
        for (result in results) handleCssRendererResult(result);
    }

    inline function handleStyle(id:String, s:VStyle) {
      if (defined.contains(id)) {
        classNames.push(renderer.renderClassName(id));
      } else {
        defined.push(id);
        handleCssRendererResult(renderer.render(s));
      }
    }

    for (s in style) switch s {
      case VStyleDef(type, props):
        var id = type.getStyleId(props);
        handleStyle(id, s);
      case VStyleInline(id, _):
        handleStyle(id, s);
      case VStyleList(styles):
        classNames = classNames.concat(processClasses(styles));
    }

    return classNames;
  }

  function insertRule(name:String, css:String) {
    sheet.insertRule(
      '@media all { ${css} }',
      switch indices[name] {
        case null: indices[name] = sheet.cssRules.length;
        case v: v;
      }
    );
  }
}
