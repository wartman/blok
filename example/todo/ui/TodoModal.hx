package todo.ui;

// import blok.style.Background;
import todo.style.Overlay;
import blok.scaffold.Portal;
import todo.style.Config;
import todo.style.Card;

using Blok;

class TodoModal extends Component {
  
  @prop var onSave:(value:String)->Void;
  @prop var requestClose:()->Void = null;

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
              }, 'modal'),
              // Background.style({
              //   color: Config.darkColor
              // }, 'modal')
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