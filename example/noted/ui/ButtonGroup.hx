package noted.ui;

import blok.ui.style.Grid;
import noted.ui.style.Config;

using Blok;

class ButtonGroup extends Component {
  @prop var style:Null<StyleList> = null;
  @prop var buttons:Array<VNode>;

  override function render(context:Context):VNode {
    var grid = Grid.style({
      columns: GridDefinition.repeat(3, Fr(1)),
      gap: Config.mediumGap
    });

    return Html.div({
      style: switch style {
        case null: grid;
        case s: s.add(grid); 
      },
      children: buttons
    });
  }
}