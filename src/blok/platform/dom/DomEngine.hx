package blok.platform.dom;

import js.Browser;
import js.html.Text;
import js.html.Element;
import blok.core.Component;
import blok.core.Cursor;
import blok.core.Differ;
import blok.core.Engine;
import blok.core.Node;

class DomEngine implements Engine {

  inline public static final SVG_NS = 'http://www.w3.org/2000/svg';
  
  public final differ:Differ = new Differ();

  public function new() {}

  public function createNode(tag:String):Node {
    return cast Browser.document.createElement(tag);
  }

  public function createSvgNode(tag:String):Node {
    return cast Browser.document.createElementNS(SVG_NS, tag);
  }

  public function createTextNode(content:String):Node {
    return cast Browser.document.createTextNode(content);
  }

  public function updateTextNode(node:Node, content:String):Void {
    var text:Text = cast node;
    text.textContent = content;
  }

  public function updateNodeAttr(
    node:Node,
    key:String,
    oldValue:Dynamic,
    newValue:Dynamic
  ) {
    var el:Element = cast node;
    var isSvg = el.namespaceURI == SVG_NS;
    switch key {
      case 'className':
        updateNodeAttr(node, 'class', oldValue, newValue);
      case 'xmlns' if (isSvg): // skip
      case 'value' | 'selected' | 'checked' if (!isSvg):
        js.Syntax.code('{0}[{1}] = {2}', el, key, newValue);
      case _ if (!isSvg && js.Syntax.code('{0} in {1}', key, el)):
        js.Syntax.code('{0}[{1}] = {2}', el, key, newValue);
      default: 
        if (key.charAt(0) == 'o' && key.charAt(1) == 'n') {
          var name = key.toLowerCase();
          if (newValue == null) {
            Reflect.setField(el, name, null);
          } else {
            Reflect.setField(el, name, newValue);
          }
          // var ev = key.substr(2).toLowerCase();
          // el.removeEventListener(ev, oldValue);
          // if (newValue != null) el.addEventListener(ev, newValue);
        } else if (newValue == null || (Std.is(newValue, Bool) && newValue == false)) {
          el.removeAttribute(key);
        } else if (Std.is(newValue, Bool) && newValue == true) {
          el.setAttribute(key, key);
        } else {
          el.setAttribute(key, newValue);
        }
    }
  }

  public function dangerouslySetInnerHtml(node:Node, html:String):Void {
    var el:Element = cast node;
    el.innerHTML = html; 
  }

  public function traverseSiblings(first:Node):Cursor {
    return new DomCursor(first.parentNode, first);
  }

  public function traverseChildren(parent:Node):Cursor {
    return new DomCursor(parent, parent.firstChild);
  }

  public function placeholder(target:Component) {
    return blok.platform.dom.Html.text('');
  }

}
