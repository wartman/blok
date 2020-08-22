import todo.ui.App;

using Blok;

class Todo {

  static function main() {
    Platform.mount(
      js.Browser.document.getElementById('root'),
      context -> App.node({})
    );
  }

}
