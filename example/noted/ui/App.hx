package noted.ui;

import blok.ui.PortalManager;
import blok.ui.style.*;
import noted.state.Note;
import noted.state.NoteRepository;
import noted.ui.style.Config;
import noted.ui.style.Root;

using Blok;

class App extends Component {
  override function render(context:Context):VNode {
    return NoteRepository.provide({
      notes: [
        new Note({
          id: 1,
          title: 'Test',
          status: Published,
          content: 'Foo',
          tags: [ 'foo' ]
        })
      ]
    }, ctx -> PortalManager.node({
      children: [
        Html.div({
          style: [
            Flex.style({
              direction: Row,
              justifyContent: Content(Center)
            }, 'root'),
            Root.style()
          ],
          children: [
            Html.div({
              style: [
                Box.style({
                  width: Config.mobileWidth,
                  padding: EdgeInsets.symmetric(Em(1), None)
                }),
                Style.define([
                  MediaQuery.maxWidth(Config.mobileWidth, [
                    Box.export({
                      width: Pct(100),
                      padding: EdgeInsets.all(Config.smallGap)
                    })
                  ])
                ])
              ],
              children: [NoteList.node({}) ]
            })
          ]
        })
      ]
    }));
  }
}
