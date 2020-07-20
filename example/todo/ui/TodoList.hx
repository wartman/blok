package todo.ui;

import blok.style.*;
import todo.state.TodoState;

using Blok;
using BlokDom;

class TodoList extends Component {

  override function render(context:Context):VNode {
    return TodoState.subscribe(context, state -> Html.ul({
      style: Box.style({
        padding: EdgeInsets.symmetric(Px(20), None)
      }),
      children: if (state.visibleTodos.length == 0) [
        TodoPlaceholder.node({})
      ] else  [
        for (todo in state.visibleTodos) TodoItem.node({ todo: todo })
      ]
    }));
  }

}
