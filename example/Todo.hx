import todo.ui.App;

using BlokDom;

class Todo {

  static function main() {
    DomPlatform.mount(
      js.Browser.document.getElementById('root'),
      context -> App.node({})
    );
  }

}
