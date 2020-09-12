package todo.ui;

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
    return Html.li({
      key: todo.id,
      style: Card.style({
        height: Px(150)
      }),
      attrs: {
        ondblclick: _ -> startEditing()
      },
      children: [
        Ui.header({
          title: 'Todo ${todo.id}',
          requestClose: () -> TodoState.from(context).removeTodo(todo)
        }),
        if (isEditing) TodoInput.node({
          onSave: value -> todo.content = value,
          requestClose: stopEditing,
          initialValue: todo.content
        }) else Html.fragment([
          Html.input({
            attrs: {
              type: Checkbox,
              checked: todo.complete,
              onclick: e -> {
                e.stopPropagation();
                TodoState.from(context).toggleTodoComplete(todo);
              }
            }
          }),
          Html.span({
            children: [ Html.text(todo.content) ]
          })
        ])
      ]
    });
  }
}
