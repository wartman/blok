package noted.ui.tag;

import blok.ui.style.*;
import noted.data.Tag;
import noted.data.Id;
import noted.ui.style.*;

using Blok;

class TagItem extends Component {
  @prop var tag:Tag;
  @prop var requestRemove:(id:Id<Tag>)->Void;
  @prop var requestSearch:Null<(id:Id<Tag>)->Void>;
  @prop var showError:Bool = false;

  override function render(context:Context):VNode {
    return Html.li({
      key: tag,
      style: [
        Position.style({ type: Relative }),
        if (showError && (tag.id.isInvalid() || tag.notes.length == 0))
          Pill.style({
            color: Config.errorColor,
            centered: false
          })
        else 
          Pill.style({
            color: Config.lightColor,
            centered: false
          })
      ],
      children: [
        Html.span({
          style: [
            Display.style({ kind: Block }),
            Box.style({
              height: Em(2),
              padding: EdgeInsets.right(Em(1)) 
            })
          ],
          children: [ Html.text(tag.name) ]
        }),
        ButtonGroup.node({
          perRow: if (requestSearch == null) 1 else 2,
          gap: Em(.5),
          style: [
            Position.style({ 
              type: Absolute, 
              right: Em(.75), 
              top: Em(.75)
            })
          ],
          buttons: [
            if (requestSearch != null) button(requestSearch, '?') else null,
            button(requestRemove, 'X')
          ]
        })
      ]
    });
  }

  inline function button(action:(id:Id<Tag>)->Void, label:String) {
    return Html.button({
      style: [
        Circle.style({
          color: Config.whiteColor,
          radius: Em(1.5)
        }),
        Css.define({ cursor: 'pointer' }),
      ],
      attrs: {
        onclick: _ -> action(tag.id)
      },
      children: [ Html.text(label) ]
    });
  }
}
