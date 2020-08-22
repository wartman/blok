package todo.ui;

import js.Browser;
import blok.ui.style.Background;
import blok.ui.Portal;
import blok.core.Delay;
import blok.util.Body;
import todo.style.Overlay;
import todo.style.Config;
import todo.style.Card;

using Blok;

class TodoModal extends Component {
  @prop var onSave:(value:String)->Void;
  @prop var requestClose:()->Void = null;

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

  override function render(context:Context):VNode {
    return Portal.node({
      child: Html.div({
        style: Overlay.style({}),
        attrs: {
          onclick: e -> {
            e.preventDefault();
            requestClose();
          }
        },
        children: [
          Html.div({
            style: [
              Card.style({
                color: Config.lightColor
              }, 'modal')
            ],
            attrs: {
              onclick: e -> e.stopPropagation()
            },
            children: [
              Html.h1({ children: [ Html.text('Add todo') ] }),
              TodoInput.node({
                requestClose: requestClose,
                placeholder: 'What needs doing?',
                onSave: onSave
              })
            ]
          })
        ]
      })
    });
  }
}
