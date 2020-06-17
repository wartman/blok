package todo.ui;

import todo.state.TodoState;

using Blok;

class TodoList extends Component {

  override function render(context:Context):VNode {
    return TodoState.consume(context, state -> Html.ul({
      children: [
        for (todo in state.visibleTodos) TodoItem.node({ todo: todo })
      ]
    }));
  }

}
