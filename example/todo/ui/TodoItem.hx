package todo.ui;

import todo.state.TodoState;
import todo.state.Todo;

using Blok;

class TodoItem extends Component {

  @prop var todo:Todo;
  @prop var isEditing:Bool = false;

  @update
  function toggleEditing() {
    return { isEditing: !isEditing };
  }
  
  override function render(context:Context):VNode {
    return TodoState.consume(context, state -> 
      Html.li({
        key: todo,
        attrs: {
          ondblclick: e -> toggleEditing()
        },
        children: [
          if (isEditing) {
            TodoInput.node({
              onSave: value -> todo.content = value,
              onEscape: toggleEditing,
              initialValue: todo.content
            });
          } else {
            Html.fragment([
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
      })
    );
  }

}
