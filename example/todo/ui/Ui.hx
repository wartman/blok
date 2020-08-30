package todo.ui;

import todo.style.*;
import blok.ui.style.*;

using Blok;

class Ui {
  public static function header(props:{ 
    title:String,
    ?requestClose:()->Void
  }):VNode {
    return Html.header({
      style: Style.define([
        // Style.property('height', Em(4)),
        // Style.property('margin-top', Config.smallGap.negate()),
        Css.export({
          height: Em(4),
          marginTop: Config.smallGap.negate()
        }),
        Position.export({ type: Relative }),
        Font.export({ lineHeight: Em(4) })
      ]),
      children: [
        Html.h3({ children: [ Html.text(props.title) ] }),
        if (props.requestClose != null) {
          Html.button({
            style: Style.define([
              Display.export({ kind: Block }),
              Font.export({ 
                size: Em(1),
                lineHeight: Pct(100)
              }),
              Box.export({ 
                height: Em(2),
                padding: EdgeInsets.symmetric(None, Em(.5))
              }),
              Position.export({ 
                type: Absolute, 
                top: Config.smallGap, 
                right: Num(0)
              }),
            ]),
            attrs: {
              onclick: _ -> props.requestClose()
            },
            children: [ Html.text('x') ]
          });
        } else null
      ]
    });
  }
}
