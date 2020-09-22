package noted.ui;

import blok.ui.style.*;
import noted.state.Note;
import noted.state.NoteRepository;

using Blok;

class App extends Component {
  override function render(context:Context):VNode {
    return Html.div({
      style: [
        Flex.style({
          direction: Row,
          justifyContent: Content(Center)
        }, 'root')
      ],
      children: [
        Html.div({
          style: [
            Box.style({
              width: Px(900),
              padding: EdgeInsets.symmetric(Em(1), None)
            }),
            Style.define([
              MediaQuery.maxWidth(Px(900), [
                Box.export({
                  width: Pct(100),
                  padding: EdgeInsets.all(Em(1))
                })
              ])
            ])
          ],
          children: [
            NoteRepository.provide({
              notes: [
                new Note({
                  id: 1,
                  title: 'Test',
                  status: Published,
                  content: 'Foo',
                  tags: [ 'foo' ]
                })
              ]
            }, ctx -> NoteList.node({}))
          ]
        })
      ]
    });
  }
}
