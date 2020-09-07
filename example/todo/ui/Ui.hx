package todo.ui;

import js.html.Event;
import blok.ui.style.*;
import todo.style.*;

using Blok;

class Ui {
  public static function header(props:{ 
    title:String,
    ?requestClose:()->Void
  }):VNode {
    return Html.header({
      style: [
        Css.define({
          height: Em(4),
          marginTop: Config.smallGap.negate()
        }),
        Position.style({ type: Relative }, 'ui-header'),
        Font.style({ lineHeight: Em(4) }, 'ui-header')
      ],
      children: [
        Html.h3({ 
          children: [ Html.text(props.title) ] 
        }),
        if (props.requestClose != null)
          closeButton({ onClick: _ -> props.requestClose() })
        else null
      ]
    });
  }

  public static function closeButton(props:{
    onClick:(e:Event)->Void
  }):VNode {
    return Html.button({
      style: [
        Font.style({ 
          weight: Bold,
          size: Em(1),
          lineHeight: Pct(100)
        }, 'ui-button'),
        Position.style({ 
          type: Absolute, 
          top: Config.smallGap, 
          right: Num(0)
        }, 'ui-button'),
        Card.style({
          color: Config.midColor,
          padding: EdgeInsets.symmetric(None, Em(.5)),
          height: Em(2)
        }),
        Display.style({ kind: Block })
      ],
      attrs: {
        onclick: props.onClick
      },
      children: [ Html.text('X') ]
    });
  }

  public static function input(props:{
    ?ref:(node:js.html.Node)->Void,
    ?onInput:(e:js.html.KeyboardEvent)->Void,
    ?value:String,
    ?placeholder:String
  }) {
    return Html.input({
      style: [
        Font.style({
          size: Em(1),
          lineHeight: Pct(100)
        }, 'ui-input'),
        Card.style({
          color: Config.whiteColor,
          padding: EdgeInsets.symmetric(None, Em(.5)),
          height: Em(2)
        })
      ],
      ref: props.ref,
      attrs: {
        onkeydown: e -> if (props.onInput != null) props.onInput(cast e),
        value: props.value,
        placeholder: props.placeholder
      }
    });
  }
}
