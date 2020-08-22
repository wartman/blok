package todo.ui;

import blok.ui.style.*;
import todo.style.Config;
import todo.style.Card;
import todo.state.TodoState;
import todo.state.Todo;

using Blok;

class TodoItem extends Component {
  @prop var todo:Todo;
  @prop var isEditing:Bool = false;

  @update
  function startEditing() {
    if (isEditing) return null;
    return { isEditing: true };
  }

  @update
  function stopEditing() {
    if (!isEditing) return null;
    return { isEditing: false };
  }
  
  override function render(context:Context):VNode {
    // Note: we could use `TodoState.subscribe` here, but
    //       this component will always be the child of 
    //       a `TodoList`, which is already subscribed to TodoState.
    //       This actually would work fine -- Blok won't
    //       rerender a child component if the parent is
    //       already rendering -- but this is just an illustration
    //       of how to use state without subscribing to it.
    var state = TodoState.forContext(context);
    return Html.li({
      key: todo.id,
      style: [
        Box.style({
          spacing: EdgeInsets.symmetric(Config.mediumGap, Px(0))
        }),
        Card.style({})
      ],
      attrs: {
        ondblclick: _ -> startEditing()
      },
      children: [
        if (isEditing) {
          TodoInput.node({
            onSave: value -> todo.content = value,
            requestClose: stopEditing,
            initialValue: todo.content
          });
        } else {
          Html.fragment([
            Html.input({
              attrs: {
                type: Checkbox,
                checked: todo.complete,
                onclick: e -> {
                  e.stopPropagation();
                  state.toggleTodoComplete(todo);
                }
              }
            }),
            Html.span({
              children: [ Html.text(todo.content) ]
            }),
            Html.button({
              attrs: {
                onclick: _ -> state.removeTodo(todo)
              },
              children: [ Html.text('X') ]
            })
          ]);
        }
      ]
    });
  }
}
