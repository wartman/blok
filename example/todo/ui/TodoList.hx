package todo.ui;

import todo.style.CardGrid;
import todo.state.TodoState;

using Blok;

class TodoList extends Component {
  override function render(context:Context):VNode {
    return TodoState.subscribe(context, state -> Html.ul({
      style: CardGrid.style({}),
      children: if (state.visibleTodos.length == 0) [
        TodoPlaceholder.node({})
      ] else  [
        for (todo in state.visibleTodos) TodoItem.node({ todo: todo })
      ]
    }));
  }
}
