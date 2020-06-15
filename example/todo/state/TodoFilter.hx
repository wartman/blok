package todo.state;

enum abstract TodoFilter(String) from String to String {
  var FilterAll;
  var FilterCompleted;
  var FilterPending;
}
