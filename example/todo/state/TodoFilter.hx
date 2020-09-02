package todo.state;

enum abstract TodoFilter(String) from String to String {
  var FilterAll = 'all';
  var FilterCompleted = 'complete';
  var FilterPending = 'pending';
}
