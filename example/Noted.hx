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
            new Note({
              id: 0,
              name: 'Test',
              status: Published,
              content: 'Foo',
              tags: [ 2 ]
            }),
            new Note({
              id: 1,
              name: 'Other Test',
              status: Published,
              content: 'Foo bar',
              tags: [ 2 ]
            })
          ],
          tags: [
            new Tag({
              id: 2,
              name: 'foo',
              notes: [ 0, 1 ]
            })
          ]
        })
      })
    );
  }
}
