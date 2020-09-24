package noted.ui;

import blok.ui.style.Grid;
import blok.ui.style.*;
import noted.ui.style.Pill;
import noted.ui.style.Config;
import noted.state.Note;
import noted.state.NoteRepository;

using Blok;

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
        })
      ],
      children: [
        for (tag in note.tags) Html.li({
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
                })
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
          children: [
            if (adding) Html.input({
              style: Pill.style({
                outlined: true,
                color: Config.darkColor,
                centered: false,
                padding: Em(.5)
              }),
              attrs: {
                placeholder: 'add tag',
                onblur: _ -> stopAdding(),
                onkeydown: e -> {
                  var ev:js.html.KeyboardEvent = cast e;
                  var input:js.html.InputElement = cast ev.target;
                  if (ev.key == 'Enter') {
                    stopAdding();
                    NoteRepository
                      .from(context)
                      .addTagsToNote(note, [ input.value ]);
                  } else if (ev.key == 'Escape') {
                    stopAdding();
                  }
                }
              }
            }) else Html.div({
              style: [
                Box.style({
                  padding: EdgeInsets.symmetric(Em(.5), None)
                })
              ],
              children: [
                Button.node({
                  onClick: _ -> startAdding(),
                  child: Html.text('Add Tag')
                })
              ]
            })
          ]
        })
      ])
    });
  }
}
