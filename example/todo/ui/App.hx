package todo.ui;

import todo.state.TodoFilter;
import blok.ui.RouterState;
import blok.ui.history.BrowserHistory;
import blok.ui.PortalManager;
import todo.style.Card;
import todo.style.Root;
import todo.state.AppState;
import todo.state.TodoState;
import todo.state.TodoRoute;

using Blok;

class App extends Component {
  override function render(context:Context):VNode {
    return AppState.provide(context, {
      title: 'Todo',
      router: {
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
      },
      todos: {
        todos: []
      }
    }, childContext -> PortalManager.node({
      children: [
        Html.div({
          style: Root.style({}),
          children: [
            Html.header({
              style: Card.style({}),
              children: [
                Html.h1({
                  children: [
                    AppState.subscribe(childContext, state -> Html.text(state.title))
                  ]
                }),
                // Because AppState provides a TodoState it is now
                // available in the current Context.
                TodoState.subscribe(childContext, state -> TodoInput.node({
                  onSave: value -> state.addTodo(value),
                  placeholder: 'Add Todo'
                })),
                RouterState.subscribe(childContext, (state:RouterState<TodoRoute>) -> Html.text(switch state.route {
                  case Home: 'home';
                  case NotFound(url): '${url} not found';
                  case Filter(filter): Std.string(filter);
                }))
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
