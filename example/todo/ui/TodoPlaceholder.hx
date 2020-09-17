package todo.ui;

import todo.state.TodoState;
import todo.style.Config;
import todo.style.Card;

using Blok;

enum ModalState {
  Show;
  Hide;
}

class TodoPlaceholder extends Component {
  // @prop var showModal:Bool = false;

  // @update
  // function toggleModal() {
  //   return { showModal: !showModal };
  // }

  // @update
  // function hideModal() {
  //   return { showModal: false };
  // }

  // Just testing this out! It's not really better than just
  // using props and update, really, but I want to check that
  // it works.
  final modal:Observable<ModalState> = new Observable(Hide);

  override function render(context:Context):VNode {
    return Html.li({
      style: Card.style({
        color: Config.midColor,
        height: Px(150)
      }),
      attrs: {
        // ondblclick: _ -> toggleModal()
        ondblclick: _ -> modal.notify(Show)
      },
      children: [ 
        Html.text('No todos'),
        modal.mapToNode(state -> switch state {
          case Show: TodoModal.node({
            requestClose: () -> modal.notify(Hide),
            onSave: value -> {
              TodoState.from(context).addTodo(value);
              modal.notify(Hide);
            }
          });
          case Hide: null;
        })
        // if (showModal)
        //   TodoModal.node({
        //     requestClose: hideModal,
        //     onSave: value -> {
        //       TodoState.from(context).addTodo(value);
        //       hideModal();
        //     }
        //   })
        // else
        //   null
      ]
    });
  }
}
