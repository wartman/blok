package todo.state;

import blok.ui.RouterState;

using Blok;

class AppState extends State {
  @prop var title:String;
  @state var todos:TodoState;
  @state var router:RouterState<TodoRoute>;
  @subscribe(target = todos) var filter:TodoFilter;
  @subscribe(target = todos) var remainingTodos:Int;

  @update
  public function addTodo(content:String) {
    // An example of how you can update substates
    // from a parent state. Note that you don't pass in
    // new props for sub states -- instead, you pass arguments
    // to the substate's `update` methods. This is similar to
    // `actions` in redux.
    return {
      todos: {
        addTodo: { content: content }
      }
    };
  }

  @update
  public function removeCompleted() {
    return {
      todos: { 
        removeCompleted: true 
      },
      router: {
        setRoute: { route: Home }
      }
    };
  }

  @init
  function watchHistory() {
    js.Browser.window.addEventListener('popstate', (e) -> {
      router.setUrl(router.history.getLocation(), false);
    });
  }

  @update
  public function setFilter(filter:TodoFilter) {
    return {
      todos: { 
        setFilter: { filter: filter }
      },
      router: {
        setRoute: { route: Filter(filter) }
      }
    };
  }
}
