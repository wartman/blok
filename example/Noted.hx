import blok.core.Plugin;
import noted.ui.App;
import noted.data.*;

using Blok;

class Noted {
  static function main() {
    Platform.mount(
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
      })
    );
  }
}
