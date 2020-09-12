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
        Position.style({ 
          type: Absolute, 
          top: Config.smallGap, 
          right: Num(0)
        }, 'ui-closeButton'),
        Css.define({
          cursor: 'pointer'
        }),
        Circle.style({
          color: Config.midColor
        })
      ],
      attrs: {
        onclick: props.onClick
      },
      children: [ Html.text('X') ]
    });
  }

  public static function button(props:{
    label:String,
    onClick:(e:Event)->Void,
    ?selected:Bool
  }):VNode {
    return Html.button({
      style: [
        Css.define({
          cursor: 'pointer'
        }),
        if (!props.selected)
          Pill.style({
            color: Config.midColor,
            outlined: true
          })
        else
          Pill.style({
            color: Config.midColor
          })
      ],
      attrs: {
        disabled: props.selected,
        onclick: props.onClick
      },
      children: [ Html.text(props.label) ]
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
        Box.style({ width: Pct(100) }),
        Pill.style({
          color: Config.whiteColor,
          centered: false
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
