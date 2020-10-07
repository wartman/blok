package noted.ui;

import blok.ui.style.Grid;
import blok.ui.style.*;
import noted.ui.style.Pill;
import noted.ui.style.Config;
import noted.data.Tag;
import noted.data.Id;

using Blok;

class NoteTags extends Component {
  @prop var tags:Array<Tag>;
  @prop var addTag:(name:String)->Void;
  @prop var removeTag:(id:Id<Tag>)->Void;
  @prop var adding:Bool = false;

  @update
  function stopAdding() {
    return UpdateState({ adding: false });
  }

  @update
  function startAdding() {
    return UpdateState({ adding: true });
  }

  override function render(context:Context):VNode {
    return Html.ul({
      style: [
        Grid.style({
          columns: GridDefinition.repeat(5, Fr(1)),
          gap: Config.mediumGap
        }),
        Style.define([
          MediaQuery.maxWidth(Config.mobileWidth, [
            Grid.export({
              columns: GridDefinition.repeat(3, Fr(1))
            })
          ])
        ])
      ],
      children: [
        for (tag in tags) Html.li({
          key: tag,
          style: [
            Flex.style({
              direction: Row
            }),
            if (tag.id.isInvalid())
              Pill.style({
                // outlined: true,
                color: Config.errorColor,
                centered: false
              })
            else 
              Pill.style({
                // outlined: true,
                color: Config.lightColor,
                centered: false
              }),
            Position.style({ type: Relative })
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
                Border.style({
                  width: None,
                  type: None
                }),
                Background.style({
                  color: Color.name('transparent')
                }),
                Font.style({
                  lineHeight: Em(2.5),
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
                onclick: _ -> removeTag(tag.id)
              },
              children: [ Html.text('X') ]
            })
          ]
        })
      ].concat([ 
        Html.li({
          key: 'add-tag',
          children: [
            if (adding) Input.node({
              style: [
                Box.style({ width: Pct(100) }),
              ],
              onSave: value -> {
                addTag(value);
                stopAdding();
              },
              onCancel: stopAdding
            }) else Html.button({
              style: [
                Display.style({ kind: Block }),
                Box.style({ width: Pct(100) }),
                Pill.style({
                  color: Config.midColor,
                  padding: Em(.5),
                  outlined: true
                }),
                Style.define([
                  Style.property('cursor', 'pointer')
                ])
              ],
              attrs: {
                onclick: _ -> startAdding()
              },
              children: [ Html.text('Add Tag') ]
            })
          ]
        })
      ])
    });
  }
}
