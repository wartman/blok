package noted.ui;

import blok.ui.style.Grid;
import blok.ui.style.*;
import noted.ui.style.Pill;
import noted.ui.style.Config;
import noted.state.Note;
import noted.state.NoteRepository;

using Blok;

// @todo: make generic -- we can use this same component to filter
//        tags in the control system.
class NoteTags extends Component {
  @prop var note:Note;
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
        for (tag in note.tags) Html.li({
          key: tag,
          style: [
            Flex.style({
              direction: Row
            }),
            Pill.style({
              outlined: true,
              color: Config.darkColor,
              centered: false,
              padding: Em(.5)
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
              children: [ Html.text(tag) ]
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
                  lineHeight: Em(2.5)
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
                onclick: _ -> NoteRepository
                  .from(context)
                  .removeTagsFromNote(note, [ tag ]),
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
                stopAdding();
                NoteRepository
                  .from(context)
                  .addTagsToNote(note, [ value ]);
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
