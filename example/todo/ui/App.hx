package todo.ui;

import todo.state.TodoState;

using Blok;

class App extends Component {

  override function render(context:Context):VNode {
    return TodoState.provide(context, {
      todos: []
    }, childContext -> Html.div({
      style: AppStyle.style({}),
      children: [
        // Note that children inside a State provider will not be updated
        // when the state is -- you need to use a State consumer to
        // subscribe to changes.
        TodoState.consume(childContext, state -> TodoInput.node({
          onSave: value -> state.addTodo(value),
          placeholder: 'Add Todo'
        })),
        TodoList.node({}),
        SiteFooter.node({})
      ]
    }));
  }

}
