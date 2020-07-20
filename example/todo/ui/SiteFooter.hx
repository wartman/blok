package todo.ui;

import todo.style.Card;
import todo.state.TodoState;

using Blok;
using BlokDom;

class SiteFooter extends Component {
  
  override function render(context:Context):VNode {
    return TodoState.subscribe(context, state -> Html.footer({
      style: Card.style({}),
      children: if (state.todos.length > 0) [
        Html.text('${state.remainingTodos} of ${state.todos.length} remaining'),
        Html.button({
          attrs: {
            onclick: _ -> state.setFilter(FilterAll),
            disabled: state.filter == FilterAll
          },
          children: [ Html.text('All') ]
        }),
        Html.button({
          attrs: {
            onclick: _ -> state.setFilter(FilterCompleted),
            disabled: state.filter == FilterCompleted
          },
          children: [ Html.text('Complete') ]
        }),
        Html.button({
          attrs: {
            onclick: _ -> state.setFilter(FilterPending),
            disabled: state.filter == FilterPending
          },
          children: [ Html.text('Pending') ]
        })
      ] else [
        Html.text('No todos yet!')
      ]
    }));
  }

}
