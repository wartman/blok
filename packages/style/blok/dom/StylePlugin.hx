package blok.dom;

import js.Browser;
import js.html.Node;
import js.html.CSSStyleSheet;
import blok.core.Plugin;
import blok.core.PluginProvider;
import blok.style.StyleList;
import blok.style.Style;
import blok.style.VStyle;
import blok.html.HtmlAttributes;

using blok.html.CssGenerator;
using Lambda;

class StylePlugin implements Plugin<Node> {
  public static function provide(build):VNode {
    return PluginProvider.provide(() -> new StylePlugin(), build);
  }

  final sheet:CSSStyleSheet;
  final defined:Array<String>;
  final indices:Map<String, Int> = [];

  public function new(?defined, useBaseStyle = false) {
    var el = Browser.document.createStyleElement();
    Browser.document.head.appendChild(el);
    sheet = cast el.sheet;
    this.defined = defined != null ? defined : [];
    if (useBaseStyle) registerBaseStyle();
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

    function addCss(s:VStyle) {
      var result = s.generate();
      for (i in 0...result.classes.length) {
        classNames.push(result.classes[i]);
        insertRule(result.classes[i], result.rules[i]);
      }
    }

    for (s in style) switch s {
      case VStyleDef(type, props, suffix):
        var name = type.getStyleName(props, suffix);
        if (defined.contains(name)) {
          classNames.push(name.getUniqueClassName());
        } else {
          defined.push(name);
          addCss(s);
        }
      case VStyleInline(name, def):
        if (defined.contains(name)) {
          classNames.push(name.getUniqueClassName());
        } else {
          defined.push(name);
          addCss(s);
        }
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