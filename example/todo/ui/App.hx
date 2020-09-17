package todo.ui;

import blok.ui.RouterState;
import blok.ui.history.HashHistory;
import blok.ui.PortalManager;
import todo.style.Card;
import todo.style.Root;
import todo.style.MainTitle;
import todo.state.TodoState;
import todo.state.TodoFilter;
import todo.state.TodoRoute;

using Blok;

class App extends Component {
  final todos:TodoState = new TodoState({ todos: [] });
  final router:RouterState<TodoRoute> = new RouterState({
    urlToRoute: url -> switch url.split('-') {
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
      case Home: '';
      case NotFound(url): url;
      case Filter(filter): 'filter-${filter}';
    },
    history: new HashHistory()
  });

  @init
  function setupFilter() {
    router.getObservable().observe(router -> {
      switch router.route {
        case Home: todos.setFilter(FilterAll);
        case Filter(filter): todos.setFilter(filter);
        default:
      }
    });
  }

  @dispose
  function removeObservers() {
    todos.getObservable().dispose();
    router.getObservable().dispose();
  }

  override function render(context:Context):VNode {
    return ObservableProvider.provide(
      [ todos, router ], 
      ctx -> PortalManager.node({
        children: [
          Html.div({
            style: Root.style({}),
            children: [
              Html.header({
                style: Card.style({}),
                children: [
                  Html.h1({
                    style: MainTitle.style({}),
                    attrs: {
                      onclick: _ -> RouterState.from(ctx).setRoute(Home) 
                    },
                    children: [ 
                      Html.text('Todos '),
                      RouterState.observe(ctx, state -> Html.text(switch state.route {
                        case Home: '';
                        case NotFound(_): 'NotFound';
                        case Filter(filter): switch filter {
                          case FilterAll: 'All';
                          case FilterCompleted: 'Completed';
                          case FilterPending: 'Pending'; 
                        }
                      }))
                    ]
                  }),
                  TodoInput.node({
                    onSave: value -> TodoState.from(ctx).addTodo(value),
                    placeholder: 'Add Todo'
                  })
                ]
              }),
              RouterState.observe(ctx, state -> switch state.route {
                case NotFound(url):
                  Html.div({
                    style: Card.style({}),
                    children: [ Html.text('Page not found: ${url}') ]
                  });
                default: 
                  Html.fragment([
                    TodoList.node({}),
                    SiteFooter.node({})
                  ]);
              })
            ]
          })
        ]
      })
    );
  }
}
