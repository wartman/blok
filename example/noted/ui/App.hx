package noted.ui;

import blok.ui.PortalManager;
import blok.ui.style.*;
import noted.state.Note;
import noted.state.NoteRepository;
import noted.ui.style.Config;
import noted.ui.style.Root;

using Blok;

class App extends Component {
  @prop var notes:NoteRepository;

  override function render(context:Context):VNode {
    return ObservableProvider.provide([
      notes
    ], ctx -> PortalManager.node({
      children: [
        Html.div({
          style: [
            Root.style()
          ],
          children: [
            NoteList.node({})
          ]
        })
      ]
    }));
  }
}
