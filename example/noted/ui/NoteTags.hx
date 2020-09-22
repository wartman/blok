package noted.ui;

import blok.ui.style.Grid;
import blok.ui.style.*;
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
          gap: Em(1)
        })
      ],
      children: [
        for (tag in note.tags) Html.li({
          style: [
            Flex.style({
              direction: Row
            }),
            Border.style({
              type: Solid,
              width: Px(1),
              color: Color.hex(0xffffff),
              radius: Em(1)
            }),
            Box.style({
              height: Em(2),
              padding: EdgeInsets.symmetric(None, Em(1)) 
            }),
            Font.style({
              lineHeight: Em(2)
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
              children: [ Html.text(tag) ]
            }),
            Button.node({
              onClick: _ -> NoteRepository
                .from(context)
                .removeTagsFromNote(note, [ tag ]),
              child: Html.text('x')
            })
          ]
        })
      ].concat([ 
        Html.li({
          children: [
            if (adding) Html.input({
              attrs: {
                placeholder: 'add tag',
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
            }) else Button.node({
              onClick: _ -> startAdding(),
              child: Html.text('Add Tag')
            })
          ]
        })
      ])
    });
  }
}
