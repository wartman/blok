package blok.html;

import blok.core.TextComponent;
import blok.core.NodeComponent;
import blok.core.Key;
import blok.core.VNode;
import blok.core.Node;
import blok.core.VStyleList;
import blok.html.HtmlAttrs;

typedef BaseProps<Attrs:{}> = {
  @:optional final style:VStyleList;
  @:optional final key:Key;
  @:optional final attrs:Attrs;
  @:optional final ref:(node:Node)->Void;
}

typedef ContainerProps<Attrs:{}> = BaseProps<Attrs> & {
  @:optional final children:Array<VNode>;
  @:optional final dangerouslySetInnerHtml:String;
}

typedef DefaultProps = ContainerProps<GlobalAttr & HtmlEvents>;

class Html {

  inline public static function text(content:String):VNode {
    return TextComponent.node({ content: content });
  }

  inline public static function fragment(children:Array<VNode>, ?key:Key):VNode {
    return VFragment(children, key);
  }

  inline public static function div(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'div',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function aside(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'aside',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function article(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'article',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function section(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'section',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function blockquote(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'blockquote',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function header(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'header',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function footer(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'footer',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function main(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'main',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function nav(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'nav',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function button(props:ContainerProps<ButtonAttr & HtmlEvents>):VNode {
    return NodeComponent.node({
      tag: 'button',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function table(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'table',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function thead(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'thead',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function tbody(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'tbody',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function tfoot(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'tfoot',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function tr(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'tr',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function td(props:ContainerProps<TableCellAttr & HtmlEvents>):VNode {
    return NodeComponent.node({
      tag: 'td',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function th(props:ContainerProps<TableCellAttr & HtmlEvents>):VNode {
    return NodeComponent.node({
      tag: 'th',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function h1(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'h1',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function h2(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'h2',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function h3(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'h3',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function h4(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'h4',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function h5(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'h5',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function h6(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'h6',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function strong(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'strong',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function em(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'em',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function span(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'span',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function p(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'p',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function i(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'i',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function b(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'b',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function ins(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'ins',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function del(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'del',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function small(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'small',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function menu(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'menu',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  inline public static function ul(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'ul',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function ol(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'ol',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function li(props:DefaultProps):VNode {
    return NodeComponent.node({
      tag: 'li',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function a(props:ContainerProps<AnchorAttr & HtmlEvents>):VNode {
    return NodeComponent.node({
      tag: 'a',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children, 
      style: props.style,
      key: props.key
    });
  }

  inline public static function label(props:ContainerProps<LabelAttr & HtmlEvents>):VNode {
    return NodeComponent.node({
      tag: 'label',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

  // var picture:GlobalAttr<Style>;
  //   var canvas:CanvasAttr;
  //   var audio:AudioAttr;
  //   var video:VideoAttr;
  //   var form:FormAttr;
  //   var fieldset:FieldSetAttr;
  //   var select:SelectAttr;
  //   var option:OptionAttr;
  //   var dl:GlobalAttr<Style>;
  //   var dt:GlobalAttr<Style>;
  //   var dd:GlobalAttr<Style>;
  //   var details:#if haxe4 DetailsAttr #else GlobalAttr<Style>#end;
  //   var summary:GlobalAttr<Style>;

  // VOID TAGS:
  //   var br:GlobalAttr<Style>;
  //   var embed:EmbedAttr;
  //   var hr:GlobalAttr<Style>;
  //   var img:ImageAttr;
  
  inline public static function input(props:BaseProps<InputAttr & HtmlEvents>):VNode {
    return NodeComponent.node({
      tag: 'input',
      ref: props.ref,
      attrs: props.attrs,
      style: props.style,
      key: props.key
    });
  }

  inline public static function iframe(props:ContainerProps<IFrameAttr & HtmlEvents>):VNode {
    return NodeComponent.node({
      tag: 'iframe',
      ref: props.ref,
      attrs: props.attrs,
      children: props.children,
      style: props.style,
      key: props.key
    });
  }

}
