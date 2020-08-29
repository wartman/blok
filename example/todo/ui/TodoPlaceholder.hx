package todo.ui;

import todo.state.TodoState;
import todo.style.Config;
import todo.style.Card;

using Blok;

class TodoPlaceholder extends Component {
  @prop var showModal:Bool = false;

  @update
  function toggleModal() {
    return { showModal: !showModal };
  }

  @update
  function hideModal() {
    return { showModal: false };
  }

  override function render(context:Context):VNode {
    var state = TodoState.forContext(context);
    return Html.li({
      style: Card.style({
        color: Config.midColor,
        height: Px(150)
      }),
      attrs: {
        ondblclick: _ -> toggleModal()
      },
      children: [ 
        Html.text('No todos'),
        if (showModal)
          TodoModal.node({
            requestClose: hideModal,
            onSave: value -> {
              state.addTodo(value);
              hideModal();
            }
          })
        else
          null
      ]
    });
  }
}
