package todo.ui;

import todo.state.TodoState;

using Blok;

class App extends Component {

  override function render(context:Context):VNode {
    return TodoState.provide(context, {
      todos: []
    }, state -> Html.div({
      style: AppStyle.style({})
      // etc
    }));
  }

}
