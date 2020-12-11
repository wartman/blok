package noted.ui;

import blok.core.foundation.style.Pseudo;
import blok.core.foundation.style.Position;
import noted.ui.style.*;

using Blok;

class Popover extends Component {
  @prop var content:String;
  @prop var onClick:()->Void = null;

  override function render(context:Context) {
    return Html.div({
      style: [
        Pill.style({ 
          color: Config.errorColor, 
          padding: Em(.5)
        }),
        Position.style({
          type: Absolute,
          top: Em(-3.5),
          left: Num(0)
        })
      ],
      attrs: {
        onclick: onClick != null ? _ -> onClick() : null
      },
      children: [
        Html.text(content),
        Html.div({
          style: [
            Style.define(Css.properties([
              Css.export({
                top: Em(3),
                left: Em(2),
                position: 'absolute',
                width: Em(.75),
                height: Em(.75),
                borderLeft: CssValue.compound([ Em(.75), 'solid', 'transparent' ]),
                borderRight: CssValue.compound([ Em(.75), 'solid', 'transparent' ]),
                borderTop: CssValue.compound([ Em(.75), 'solid', Config.errorColor ])
              })
            ]))
          ]
        })
      ]
    });
  }
}
