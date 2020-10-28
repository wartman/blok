package blok.dom;

#if !blok.platform.dom
  #error "blok.dom.StylePlugin can only be used with the blok.platform.dom package";
#end

import js.Browser;
import js.html.Node;
import js.html.CSSStyleSheet;
import blok.core.Plugin;
import blok.core.PluginProvider;
import blok.style.StyleList;
import blok.style.VStyle;
import blok.style.StylePluginPayload;
import blok.style.StyleToCssGenerator;
import blok.html.HtmlAttributes;

using Lambda;

// @todo: allow the user to provide their own StyleSheet or
//        style element here.
typedef StylePluginOptions = {
  /**
    A prefix that will be applied to all styles handled by
    this plugin. If left blank a simple prefix will be 
    generated.
  **/
  @:optional public final prefix:String;
  /**
    Predefined style IDs. For use in isomorphic apps (potentially).
  **/
  @:optional public final defined:Array<String>;
  /**
    If true, default styles will be skipped. These provide some
    resets that make the Style system a bit easier to use, so this
    should only be turned off if it interferes with an existing
    stylesheet.
  **/
  @:optional public final skipBaseStyles:Bool;
}

class StylePlugin implements Plugin<Node> {
  static var uid:Int = 0;

  public static function provide(?options, build):VNode {
    return PluginProvider.provide(() -> new StylePlugin(options), build);
  }

  final id:Int;
  final generator:StyleToCssGenerator;
  final sheet:CSSStyleSheet;
  final defined:Array<String>;
  final indices:Map<String, Int> = [];

  public function new(?options:StylePluginOptions) {
    if (options == null) options = {};
    var el = Browser.document.createStyleElement();
    Browser.document.head.appendChild(el);
    sheet = cast el.sheet;
    id = uid++;
    generator = new StyleToCssGenerator(options.prefix != null ? options.prefix : '_b${id}');
    defined = options.defined != null ? options.defined : [];
    if (options.skipBaseStyles != true) registerBaseStyle();
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

    function handleCssResult(result:CssResult) switch result {
      case None:
      case Definition(className, rules):
        classNames.push(className);
        insertRule(className, rules);
      case Multiple(results):
        for (result in results) handleCssResult(result);
    }

    inline function handleStyle(styleName:String, s:VStyle) {
      if (defined.contains(styleName)) {
        classNames.push(generator.getClassName(styleName));
      } else {
        defined.push(styleName);
        handleCssResult(generator.generate(s));
      }
    }

    for (s in style) switch s {
      case VStyleDef(type, props, suffix):
        var styleName = type.getStyleName(props, suffix);
        handleStyle(styleName, s);
      case VStyleInline(styleName, _):
        handleStyle(styleName, s);
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

  inline function registerBaseStyle() {
    insertRule('BLOK_ROOT_STYLE', '
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
    ');
  }
}