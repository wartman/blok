package noted.ui.tag;

import blok.ui.style.*;
import noted.data.Tag;
import noted.data.Id;
import noted.ui.style.*;

using Blok;

class TagItem extends Component {
  @prop var tag:Tag;
  @prop var requestRemove:(id:Id<Tag>)->Void;

  override function render(context:Context):VNode {
    return Html.li({
      key: tag,
      style: [
        Flex.style({ direction: Row }),
        Position.style({ type: Relative }),
        if (tag.id.isInvalid())
          Pill.style({
            color: Config.errorColor,
            centered: false
          })
        else
          Pill.style({
            outlined: true,
            color: Config.darkColor,
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
        Html.button({
          style: [
            Border.style({ type: None }),
            Background.style({ color: Color.name('transparent') }),
            Font.style({
              lineHeight: Em(2),
              color: Color.inherit()
            }),
            Position.style({
              type: Absolute,
              right: Em(.5),
              top: None
            }),
            Style.define([
              Style.property('cursor', 'pointer')
            ])
          ],
          attrs: {
            onclick: _ -> requestRemove(tag.id)
          },
          children: [ Html.text('X') ]
        })
      ]
    });
  }
}