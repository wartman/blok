package todo.ui;

import todo.state.TodoState;

using Blok;

class App extends Component {

  override function render(context:Context):VNode {
    return TodoState.provide(context, {
      todos: []
    }, state -> Html.div({
      style: AppStyle.style({}),
      children: [
        TodoInput.node({
          onSave: value -> state.addTodo(value),
          placeholder: 'Add Todo'
        }),
        TodoList.node({})
      ]
    }));
  }

}
