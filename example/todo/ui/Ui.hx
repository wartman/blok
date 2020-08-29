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
        Style.property('height', Em(2)),
        Style.property('line-height', Em(2)),
        Style.property('margin-top', Config.smallGap.negate()),
        Position.export({ type: Relative }),
        Font.export({ size: Em(1) })
      ]),
      children: [
        Html.h3({ children: [ Html.text(props.title) ] }),
        if (props.requestClose != null) {
          Html.button({
            style: Style.define([
              Position.export({ type: Absolute, top: Num(0), right: Num(0) }),
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
