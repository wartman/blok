package noted.ui;

import noted.ui.style.BaseGrid;
import noted.ui.style.Config;

using Blok;

class ButtonGroup extends Component {
  @prop var style:Null<StyleList> = null;
  @prop var buttons:Array<VNode>;
  @prop var perRow:Int = 5;
  @prop var perRowMobile:Int = null;
  @prop var gap:CssUnit = Config.mediumGap;

  override function render(context:Context):VNode {
    return Html.nav({
      style: [
        BaseGrid.style({ 
          perRow: perRow,
          perRowMobile: perRowMobile != null ? perRowMobile : perRow,
          gap: gap 
        }),
        style
      ],
      children: buttons
    });
  }
}
