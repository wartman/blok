package todo.ui;

import blok.ui.style.Grid;
import blok.ui.RouterState;
import todo.state.TodoState;
import todo.state.TodoRoute;
import todo.style.*;

using Blok;

class SiteFooter extends Component {
  override function render(context:Context):VNode {
    return TodoState.observe(context, state -> Html.footer({
      style: [
        Card.style({}),
        Grid.style({
          columns: GridDefinition.repeat(4, Fr(1)),
          gap: Config.mediumGap
        })
      ],
      children: if (state.todos.length > 0) [
        Html.div({
          style: Pill.style({
            color: Config.darkColor,
            outlined: true
          }),
          children: [
            Html.text('${state.remainingTodos} of ${state.todos.length} remaining'),
          ]
        }),    
        Ui.button({
          onClick: _ -> RouterState.from(context).setRoute(Filter(FilterAll)),
          selected: state.filter == FilterAll,
          label: 'All'
        }),
        Ui.button({
          onClick: _ -> RouterState.from(context).setRoute(Filter(FilterCompleted)),
          selected: state.filter == FilterCompleted,
          label: 'Complete'
        }),
        Ui.button({
          onClick: _ -> RouterState.from(context).setRoute(Filter(FilterPending)),
          selected: state.filter == FilterPending,
          label: 'Pending'
        })
      ] else [
        Html.div({
          style: Pill.style({
            color: Config.darkColor,
            outlined: true
          }),
          children: [ Html.text('No todos yet!') ]
        })
      ]
    }));
  }
}
