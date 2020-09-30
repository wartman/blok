import noted.ui.App;
import noted.state.*;

using Blok;

class Noted {
  static function main() {
    Platform.mount(
      js.Browser.document.getElementById('root'),
      context -> App.node({
        notes: new NoteRepository({
          notes: [
            new Note({
              title: 'Test',
              status: Published,
              content: 'Foo',
              tags: [ 'foo' ]
            }),
            new Note({
              title: 'Other Test',
              status: Published,
              content: 'Foo bar',
              tags: [ 'foo', 'bar' ]
            })
          ]
        })
      })
    );
  }
}
