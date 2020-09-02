package todo.ui;

import todo.state.TodoRoute;
import blok.ui.history.BrowserRouterState;
import blok.ui.history.BrowserHistory;
import todo.style.Card;
import todo.style.Root;
import todo.state.AppState;
import todo.state.TodoState;
import blok.ui.PortalManager;

using Blok;

class App extends Component {
  override function render(context:Context):VNode {
    return AppState.provide(context, {
      router: {
        router: {
          urlToRoute: url -> Home,
          routeToUrl: route -> '/',
          history: new BrowserHistory('/'),
          route: Home
        }
      },
      title: 'Todo',
      todos: { todos: [] }
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
                BrowserRouterState.subscribe(childContext, (state:BrowserRouterState<TodoRoute>) -> Html.text(switch state.route {
                  case Home: 'home';
                  case Edit(todoId): Std.string(todoId);
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
