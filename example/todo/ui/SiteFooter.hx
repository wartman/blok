package todo.ui;

import todo.state.TodoState;

using Blok;

class SiteFooter extends Component {
  
  override function render(context:Context):VNode {
    return TodoState.consume(context, state -> Html.footer({
      children: if (state.todos.length > 0) [
        Html.text('${state.remainingTodos} of ${state.todos.length} remaining'),
        Html.button({
          attrs: {
            onclick: _ -> state.setFilter(FilterAll)
          },
          children: [ Html.text('All') ]
        }),
        Html.button({
          attrs: {
            onclick: _ -> state.setFilter(FilterCompleted)
          },
          children: [ Html.text('Complete') ]
        }),
        Html.button({
          attrs: {
            onclick: _ -> state.setFilter(FilterPending)
          },
          children: [ Html.text('Pending') ]
        })
      ] else [
        Html.text('No todos yet!')
      ]
    }));
  }

}
