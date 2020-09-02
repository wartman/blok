package todo.state;

enum TodoRoute {
  Home;
  NotFound(url:String);
  Filter(filter:TodoFilter);
}
