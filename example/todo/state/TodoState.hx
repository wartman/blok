package todo.state;

using Blok;

class TodoState extends State {
  @prop var todos:Array<Todo>;
  @prop var filter:TodoFilter = TodoFilter.FilterAll;
  @computed var length:Int = todos.length;
  @computed var remainingTodos:Int = todos.filter(t -> !t.complete).length;
  @computed var visibleTodos:Array<Todo> = {
    var filtered = todos.copy();
    filtered.reverse();
    return switch filter {
      case FilterAll: filtered;
      case FilterCompleted: filtered.filter(todo -> todo.complete);
      case FilterPending: filtered.filter(todo -> !todo.complete);
    }
  }

  @update
  public function setFilter(filter:TodoFilter) {
    if (this.filter == filter) return null;
    return { filter: filter };
  }

  @update
  public function addTodo(content:String) {
    var id = todos.length > 0
      ? todos[ todos.length - 1 ].id + 1
      : 0;
    var todo = new Todo(content, id);
    
    switch filter {
      case FilterCompleted: todo.complete = true;
      default: 
    }

    return {
      todos: todos.concat([ todo ])
    };
  }

  @update
  public function removeTodo(todo:Todo) {
    return {
      todos: todos.filter(t -> t.id != todo.id)
    };
  }

  @update
  public function toggleTodoComplete(todo:Todo) {
    todo.complete = !todo.complete;
    return { 
      todos: todos 
    };
  }

  @update
  public function removeCompleted() {
    return {
      filter: FilterAll,
      todos: todos.filter(todo -> !todo.complete) 
    };
  }
}
