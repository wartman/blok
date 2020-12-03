package noted.ui;

import blok.ui.PortalManager;
import noted.data.Store;
import noted.ui.style.Root;

using Blok;

class App extends Component {
  @prop var store:Store;

  override function render(context:Context):VNode {
    return Provider.provide(store, ctx -> PortalManager.node({
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
