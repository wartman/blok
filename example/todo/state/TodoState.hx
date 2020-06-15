package todo.state;

using Blok;

class TodoState extends State {

  @prop var todos:Array<Todo>;
  @prop var filter:TodoFilter = TodoFilter.FilterAll;
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

}
