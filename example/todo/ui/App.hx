package todo.ui;

import blok.ui.RouterState;
import blok.ui.history.BrowserHistory;
import blok.ui.PortalManager;
import todo.state.TodoFilter;
import todo.state.TodoRoute;
import todo.style.Card;
import todo.style.Root;
import todo.style.MainTitle;
import todo.state.TodoState;

using Blok;

class App extends Component {
  override function render(context:Context):VNode {
    // Note: this is a shortcut for the following:
    //
    // TodoState.provide({ todos: [] }, ctx -> RouterState.provide({ ... }, ctx -> ...));
    return ObservableProvider.provide([
      new TodoState({ todos: [] }),
      new RouterState<TodoRoute>({
        urlToRoute: url -> switch url.split('/') {
          case [''] | ['', '']: Home;
          case ['filter', type]: switch (type:TodoFilter) {
            case FilterAll: Filter(FilterAll);
            case FilterCompleted: Filter(FilterCompleted);
            case FilterPending: Filter(FilterPending);
            default: NotFound(url);
          }
          default: NotFound(url);
        },
        routeToUrl: route -> switch route {
          case Home: '/';
          case NotFound(url): url;
          case Filter(filter): 'filter/${filter}';
        },
        history: new BrowserHistory('')
      })
    ], childContext -> PortalManager.node({
      children: [
        Html.div({
          style: Root.style({}),
          children: [
            Html.header({
              style: Card.style({}),
              children: [
                Html.h1({
                  style: MainTitle.style({}), 
                  children: [ Html.text('Todos') ]
                }),
                TodoState.subscribe(childContext, state -> TodoInput.node({
                  onSave: value -> state.addTodo(value),
                  placeholder: 'Add Todo'
                })),
                // RouterState.subscribe(childContext, (state:RouterState<TodoRoute>) -> Html.text(switch state.route {
                //   case Home: 'home';
                //   case NotFound(url): '${url} not found';
                //   case Filter(filter): Std.string(filter);
                // }))
              ]
            }),
            TodoList.node({}),
            SiteFooter.node({})
          ]
        })
      ]
    }));
  }
}
