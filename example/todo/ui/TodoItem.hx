package todo.ui;

import blok.style.*;
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
        style: [
          Box.style({ 
            padding: Spacing.all(Px(20)),
            margin: Spacing.sides(Px(20), Px(0)) 
          }),
          Background.style({ color: Color.hex('ccc') }),
          Border.style({ radius: Px(5) })
        ],
        attrs: {
          ondblclick: e -> toggleEditing()
        },
        children: [
          if (isEditing) {
            TodoInput.node({
              onSave: value -> todo.content = value,
              requestClose: toggleEditing,
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
      })
    );
  }

}
