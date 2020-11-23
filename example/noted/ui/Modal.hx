package noted.ui;

import js.Browser;
import blok.ui.Portal;
import blok.core.Delay;
import blok.util.Body;
import blok.ui.style.*;
import noted.ui.style.*;

using Blok;

class Modal extends Component {
  @prop var title:String;
  @prop var child:VNode;
  @prop var requestClose:()->Void;

  @init
  function setup() {
    Body.lock();
    Browser.window.addEventListener('keydown', doCloseOnEsc);
  }

  @dispose
  function cleanup() {
    Delay.add(Body.unlock);
    js.Browser.window.removeEventListener('keydown', doCloseOnEsc);
  }

  function doCloseOnEsc(e:js.html.KeyboardEvent) {
    if (e.key == 'Escape') requestClose();
  }

  override function render(context:Context) {
    return Portal.node({
      child: Html.div({
        style: Overlay.style(),
        attrs: {
          onclick: _ -> requestClose()
        },
        children: [
          Html.div({
            style: [
              Card.style({ 
                color: Config.whiteColor
              }),
              Box.style({
                width: Config.mobileWidth
              }),
              Style.define(
                MediaQuery.maxWidth(Config.mobileWidth, [
                  Box.export({
                    width: Pct(100)
                  })
                ])
              )
            ],
            attrs: {
              onclick: e -> e.stopPropagation() 
            },
            children: [
              Html.header({
                style: [
                  Position.style({ type: Relative }),
                  Box.style({
                    spacing: EdgeInsets.bottom(Config.mediumGap)
                  })
                ],
                children: [
                  Html.h3({
                    children: [ Html.text(title) ]
                  }),
                  Html.button({
                    style: [
                      Circle.style({
                        color: Config.lightColor
                      }),
                      Position.style({
                        type: Absolute,
                        top: Em(-.5),
                        right: Em(-.5)
                      })
                    ],
                    attrs: {
                      onclick: _ -> requestClose() 
                    },
                    children: [ Html.text('X') ]
                  })
                ]
              }),
              Html.div({
                children: [ child ]
              })
            ]
          })
        ]
      })
    });
  }
}
