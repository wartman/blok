package todo.state;

using Blok;

class AppState extends State {
  @state var todos:TodoState;
  @prop var title:String;

  // A way to subscribe to substate properties (not sure
  // about the API yet). This will only trigger a dispatch
  // on the parent state if the value changes. 
  @subscribe(target = todos) var remainingTodos:Int;

  @update
  public function addTodo(todo:Todo) {
    // An example of how you can update substates
    // from a parent state.
    return {
      todos: { todos: todos.todos.concat([ todo ]) }
    };
  }
}
