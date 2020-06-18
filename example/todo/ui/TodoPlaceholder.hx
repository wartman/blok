package todo.ui;

import todo.style.Appearance;
import todo.style.Card;

using Blok;

class TodoPlaceholder extends Component {

  override function render(context:Context):VNode {
    return Html.li({
      style: Card.style({
        background: Appearance.midColor
      }),
      children: [ Html.text('No todos') ]
    });
  }

}
