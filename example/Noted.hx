import blok.core.Plugin;
import noted.ui.App;
import noted.data.*;
import blok.dom.StylePlugin;

using Blok;

class Noted {
  static function main() {
    Platform.mountWithPlugins(
      js.Browser.document.getElementById('root'),
      context -> App.node({
        store: new Store({
          uid: 3,
          filter: FilterAll,
          notes: [
            {
              id: 0,
              name: 'Test',
              status: Published,
              content: 'Foo',
              tags: [ 2 ]
            },
            {
              id: 1,
              name: 'Other Test',
              status: Published,
              content: 'Foo bar',
              tags: [ 2 ]
            }
          ],
          tags: [
            {
              id: 2,
              name: 'foo',
              notes: [ 0, 1 ]
            }
          ]
        })
      }),
      [
        new StylePlugin([], true),
        // new Inspector()
      ]
    );
  }
}

// A terrible plugin, but they're pretty simple:
class Inspector implements Plugin<js.html.Node> {
  public function new() {}

  public function onCreate(content:Context, vnode:VNode):Void {
    trace(vnode);
  }

  public function onUpdate(content:Context, vnode:VNode):Void {
    trace(vnode);
  }
}
