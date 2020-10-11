package noted.ui;

import blok.ui.style.*;
import noted.ui.style.Circle;
import noted.ui.style.Pill;
import noted.ui.style.Config;
import noted.ui.style.BaseGrid;
import noted.data.Store;
import noted.data.Tag;
import noted.data.Id;

using Blok;

class NoteTags extends Component {
  @prop var tags:Array<Tag>;
  @prop var addTag:(name:String)->Void;
  @prop var removeTag:(id:Id<Tag>)->Void;
  @prop var showError:Bool = false;
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
        BaseGrid.style({})
      ],
      children: [
        for (tag in tags) Html.li({
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

            // This is rough:
            ButtonGroup.node({
              perRow: 2,
              gap: Em(.5),
              style: [
                Position.style({ 
                  type: Absolute, 
                  right: Em(.75), 
                  top: Em(.75)
                })
              ],
              buttons: [
                Html.button({
                  style: [
                    Circle.style({
                      color: Config.whiteColor,
                      radius: Em(1.5)
                    }),
                    Style.define([
                      Style.property('cursor', 'pointer')
                    ])
                  ],
                  attrs: {
                    onclick: _ -> Store.from(context).setFilter(FilterByTags([ tag.id ]))
                  },
                  children: [ Html.text('?') ]
                }),
                Html.button({
                  style: [
                    Circle.style({
                      color: Config.whiteColor,
                      radius: Em(1.5)
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
