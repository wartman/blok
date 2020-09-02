package todo.state;

import blok.ui.history.BrowserRouterState;

using Blok;

class AppState extends State {
  @prop var title:String;
  @state var todos:TodoState;
  @state var router:BrowserRouterState<TodoRoute>;

  // A way to subscribe to substate properties (not sure
  // about the API yet). This will only trigger a dispatch
  // on the parent state if the value changes. 
  @subscribe(target = todos) var remainingTodos:Int;

  // You can also define the property you want to watch:
  @subscribe(
    target = todos,
    property = remainingTodos
  ) var remainingTodosAlias:Int;

  @update
  public function addTodo(todo:Todo) {
    // An example of how you can update substates
    // from a parent state.
    return {
      todos: { todos: todos.todos.concat([ todo ]) }
    };
  }
}
